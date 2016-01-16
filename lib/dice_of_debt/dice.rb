module DiceOfDebt
  class Dice
    attr_accessor :dice

    def initialize(options)
      self.dice = Array.new(options.count) { Die.new(options) }
    end

    def roll
      dice.reduce(0) { |sum, die| sum + die.roll }
    end
  end
end
