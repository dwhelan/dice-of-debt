module DiceOfDebt
  # The Dice class creates an array of dice and allows them to be rolled together.
  class Dice
    DEFAULTS = { count: 1 }

    def initialize(options)
      options = DEFAULTS.merge(options)

      self.dice = Array.new(options[:count]) { Die.new(options) }
    end

    def roll(*fixed_rolls)
      fixed_rolls = fixed_rolls.flatten.slice(0, dice.count)
      roll_fixed(fixed_rolls) + roll_random(fixed_rolls)
    end

    def count
      dice.count
    end

    def value
      dice.map(&:value).reduce(0, :+)
    end

    private

    attr_accessor :dice

    def roll_fixed(fixed_rolls)
      fixed_rolls.map.with_index { |value, i| dice[i].roll(value) }
    end

    def roll_random(fixed_rolls)
      (fixed_rolls.count..dice.count - 1).each.map { |i| dice[i].roll }
    end
  end
end
