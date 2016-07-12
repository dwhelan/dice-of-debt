require 'ostruct'
require 'pad'

module DiceOfDebt
  # The Game class is responsible for coordinating the rolling of value dice, debt dice and aligning the rolls
  # with each iteration.
  class Game
    include Pad.entity

    attribute :score,      Integer,          default: 0
    attribute :iterations, Array[Iteration], default: []

    def start_iteration
      iterations << new_iteration if iterations.size < configuration[:iterations]
    end

    def end_iteration
      iteration.end
    end

    def iteration
      start_iteration if iterations.empty? || iterations.last.complete?
      iterations.last
    end

    def dice
      @dice ||= DiceSet.new(configuration[:dice])
    end

    def roll_dice(fixed_rolls = {})
      fail GameCompleteError, 'Cannot roll dice when the game is complete' if complete?
      rolls = iteration.roll_dice(fixed_rolls).tap do
        self.score += iteration.score
      end
      Roll.new(rolls: rolls)
    end

    def config
      yield configuration if block_given?
      configuration
    end

    def configuration
      @configuration ||=
        {
          dice: {
            value: { count: 8, sides: 6 },
            debt:  { count: 4, sides: 6 }
          },
          iterations: 10
        }
    end

    def complete?
      status == :complete
    end

    def status
      if iterations.size == configuration[:iterations] && iterations.last.complete?
        :complete
      else
        :started
      end
    end

    private

    def new_iteration
      Iteration.new(game: self)
    end
  end
end
