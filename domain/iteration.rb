require 'pad'

module DiceOfDebt
  # The Iteration class is responsible for keeping track of the new value, debt and total value for each iteration.
  class Iteration
    attr_reader :id
    attr_accessor :new_value, :debt, :previous, :next

    def initialize(previous = nil)
      @id = previous ? previous.id + 1 : 1
      self.previous  = previous
      self.debt      = 0
      self.new_value = 0
    end

    def value
      initial_value + new_value - debt
    end

    def initial_value
      previous ? previous.value : 0
    end
  end
end
