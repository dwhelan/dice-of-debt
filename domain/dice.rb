module DiceOfDebt
  # The Dice class create a set of dice and allows them to be rolled together in game play.
  class Dice
    attr_accessor :dice

    def initialize(options)
      self.dice = Array.new(options.count) { Die.new(options.sides) }
    end

    def roll
      dice.map(&:roll)
    end

    def count
      dice.count
    end
  end
end
