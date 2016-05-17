require 'pad'

module DiceOfDebt
  # The Iteration class is responsible for keeping track of the value, debt and overall score for each iteration.
  class Iteration
    attr_reader :id, :value, :debt

    def initialize(dice)
      self.dice   = dice
      self.id     = 1
      self.debt   = 0
      self.value  = 0
      self.status = :started
    end

    def roll(fixed_rolls = {})
      rolls = dice.roll(fixed_rolls).tap do
        self.value = dice[:value].value
        self.debt  = dice[:debt].value
      end
      Roll.new(id, rolls)
    end

    def score
      value - debt
    end

    def end
      self.status = :complete
    end

    def complete?
      status == :complete
    end

    private

    attr_writer :id, :value, :debt
    attr_accessor :status, :dice
  end
end
