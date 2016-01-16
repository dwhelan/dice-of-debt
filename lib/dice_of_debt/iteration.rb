module DiceOfDebt
  class Iteration
    attr_accessor :initial_value, :new_value, :debt

    def initialize(initial_value = 0)
      self.initial_value = initial_value
      self.debt          = 0
      self.new_value     = 0
    end

    def value
      initial_value + new_value - debt
    end
  end
end
