require 'ostruct'
require 'pad'

module DiceOfDebt
  # The Game class is responsible for coordinating the rolling of value dice, debt dice and aligning the rolls
  # with each iteration.
  class Game
    include Pad.entity

    def roll_value_dice
      value_dice.roll
      iteration.value = value_dice.total
    end

    def roll_debt_dice
      debt_dice.roll
      iteration.debt = debt_dice.total
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

    def value_dice
      @value_dice ||= Dice.new(configuration[:dice][:value])
    end

    def debt_dice
      @debt_dice ||= Dice.new(configuration[:dice][:debt])
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
            debt:  { count: 4, sides: 6 },
          },
          iterations: 10
        }
    end
  end
end
