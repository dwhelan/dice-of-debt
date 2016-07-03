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
      @dice ||= SetOfDice.new(configuration[:dice])
    end

    def roll_dice(fixed_rolls = {})
      iteration.roll_dice(fixed_rolls).tap do
        self.score += iteration.score
      end
    end

    def rolls
      start_iteration
      @rolls ||= [Roll.new({id: 2}), Roll.new({id: 3})]
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

    private

    def new_iteration
      Iteration.new(game: self)
    end
  end
end
