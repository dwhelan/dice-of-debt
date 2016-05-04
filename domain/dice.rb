module DiceOfDebt
  # The Dice class creates an array of dice and allows them to be rolled together.
  class Dice
    attr_reader :values

    def initialize(count, sides = 6)
      self.dice = Array.new(count) { Die.new(sides) }
    end

    def roll(*values)
      values = values.flatten.slice(0, dice.count)
      self.values = roll_specified(values) + roll_random(values)
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

    def roll_specified(values)
      values.map.with_index { |value, i| dice[i].roll(value) }
    end

    def roll_random(values)
      (values.count..dice.count - 1).each.map { |i| dice[i].roll }
    end
  end
end
