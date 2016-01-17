require 'ostruct'

module DiceOfDebt
  # The Game class is responsible for coordinating the rolling of value dice, debt dice and aligning the rolls
  # with each iteration.
  class Game
    def roll_value_dice
      iteration.new_value = value_dice.roll
    end

    def roll_debt_dice
      iteration.debt = debt_dice.roll
    end

    def end_iteration
      iterations.next if iteration.next
    end

    def value
      iteration.value
    end

    def iteration
      iterations.current
    end

    def iterations
      @iterations ||= Iterations.new(configuration.iterations)
    end

    def value_dice
      @value_dice ||= Dice.new(configuration.value_dice)
    end

    def debt_dice
      @debt_dice ||= Dice.new(configuration.debt_dice)
    end

    def config
      yield configuration if block_given?
      configuration
    end

    def configuration
      @configuration ||= begin
        sides      = 6
        roller     = RandomRoller.new(sides)
        value_dice = OpenStruct.new(count: 8, sides: sides, roller: roller)
        debt_dice  = OpenStruct.new(count: 4, sides: sides, roller: roller)

        OpenStruct.new(value_dice: value_dice, debt_dice: debt_dice, iterations: 10)
      end
    end
  end
end
