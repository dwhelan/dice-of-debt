module DiceOfDebt
  # The Iteration class is responsible for keeping track of the new value, debt and total value for each iteration.
  class Iteration
    attr_accessor :new_value, :debt

    def initialize(previous = nil)
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

    private

    attr_accessor :previous
  end
end
