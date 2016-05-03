module DiceOfDebt
  # The Dice class create a set of dice and allows them to be rolled together in game play.
  class Dice
    attr_accessor :dice
    attr_reader :value

    def initialize(count, sides = 6)
      self.dice = Array.new(count) { Die.new(sides) }
    end

    def roll(*values)
      self.value = values.map.with_index { |value, i| dice[i].roll(value) }
      self.value.fill(values.count, dice.count - values.count) { |i| dice[i].roll }
    end

    def count
      dice.count
    end

    private

    attr_writer :value
  end
end
