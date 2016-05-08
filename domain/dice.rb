module DiceOfDebt
  # The Dice class creates an array of dice and allows them to be rolled together.
  class Dice
    attr_reader :values

    DEFAULTS = { count: 1 }

    def initialize(options)
      options = DEFAULTS.merge(options.to_h)

      self.dice = Array.new(options[:count]) { Die.new(options) }
    end

    def roll(*die_rolls)
      die_rolls = die_rolls.flatten.slice(0, dice.count)
      self.values = roll_specified(die_rolls) + roll_random(die_rolls)
    end

    def count
      dice.count
    end

    def total
      values.reduce(0, :+)
    end

    private

    attr_writer :values
    attr_accessor :dice

    def roll_specified(die_rolls)
      die_rolls.map.with_index { |value, i| dice[i].roll(value) }
    end

    def roll_random(die_rolls)
      (die_rolls.count..dice.count - 1).each.map { |i| dice[i].roll }
    end
  end
end
