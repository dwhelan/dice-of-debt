require 'ostruct'
require 'pad'

module DiceOfDebt
  # The Game class is responsible for coordinating the rolling of value dice, debt dice and aligning the rolls
  # with each iteration.
  class Game
    include Pad.entity

    def roll(fixed_rolls = {})
      dice.roll(fixed_rolls).tap do
        iteration.value = dice[:value].value
        iteration.debt  = dice[:debt].value
      end
    end

    def start_iteration
      iterations << Iteration.new if iterations.size < configuration[:iterations]
    end

    def end_iteration
      iteration.end
    end

    def score
      iterations.map(&:score).reduce(0, :+)
    end

    def iteration
      start_iteration if iterations.empty? || iterations.last.complete?
      iterations.last
    end

    def iterations
      @iterations ||= []
    end

    def config
      yield configuration if block_given?
      configuration
    end

    def dice
      @dice ||= SetOfDice.new(configuration[:dice])
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
