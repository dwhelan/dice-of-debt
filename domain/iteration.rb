require 'pad'

module DiceOfDebt
  # The Iteration class is responsible for keeping track of the new value, debt and total value for each iteration.
  class Iteration
    attr_reader :id
    attr_accessor :new_value, :debt

    def initialize
      self.debt      = 0
      self.new_value = 0
    end

    def score
      new_value - debt
    end
  end
end
