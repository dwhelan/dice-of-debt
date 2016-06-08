require 'ostruct'
require 'pad'

module DiceOfDebt
  # The Game class is responsible for coordinating the rolling of value dice, debt dice and aligning the rolls
  # with each iteration.
  class Game
    include Pad.entity

    attribute :iterations, Array[Iteration]
    attribute :score, Integer, default: 0

    def start_iteration
      iterations << Iteration.new(self) if iterations.size < configuration[:iterations]
    end

    def end_iteration
      iteration.end
    end

    def iteration
      start_iteration if iterations.empty? || iterations.last.complete?
      iterations.last
    end

    def iterations
      @iterations ||= []
    end

    def dice
      @dice ||= SetOfDice.new(configuration[:dice])
    end

    def roll(fixed_rolls = {})
      iteration.roll(fixed_rolls).tap do
        self.score += iteration.score
      end
    end

    def rolls
      start_iteration
      @rolls ||= [Roll.new(2, {}), Roll.new(3, {})]
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
  end
end
