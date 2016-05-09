module DiceOfDebt
  # The SetOfDice class creates a set of dice and allows them to be rolled together.
  class SetOfDice
    attr_reader :values

    def initialize(options = {})
      self.dice = Hash[options.map { |name, dice_options| [name, Dice.new(dice_options)] }]
    end

    def roll(dice_rolls = {})
      self.values = roll_random.merge(roll_specified(dice_rolls))
    end

    def [](name)
      dice[name]
    end

    private

    attr_writer :values
    attr_accessor :dice

    def roll_specified(dice_rolls)
      rolls_to_use = dice_rolls.select { |k, _| dice.key?(k) }
      rolls_to_use.each_with_object({}) { |(k, v), rolls| rolls[k] = dice[k].roll(v) }
    end

    def roll_random
      dice.each_with_object({}) { |(k, _), rolls| rolls[k] = dice[k].roll }
    end
  end
end
