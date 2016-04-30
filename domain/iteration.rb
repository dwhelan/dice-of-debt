require 'pad'

module DiceOfDebt
  # The Iteration class is responsible for keeping track of the value, debt and overall score for each iteration.
  class Iteration
    attr_accessor :id, :value, :debt

    def initialize
      self.id    = 1
      self.debt  = 0
      self.value = 0
    end

    def score
      value - debt
    end
  end
end
