module DiceOfDebt
  # The SetOfDice class creates a set of dice and allows them to be rolled together.
  class SetOfDice
    attr_reader :values

    def initialize(set = {})
      self.set = set
    end

    def roll(values = {})
      self.values = roll_random.merge(roll_specified(values))
    end

    def roll_specified(values)
      values.each_with_object({}) do |(k, v), rolls|
        rolls[k] = set[k].roll(v) if set.key?(k)
      end
    end

    def roll_random
      set.each_with_object({}) { |(k, _), rolls| rolls[k] ||= set[k].roll }
    end

    private

    attr_writer :values
    attr_accessor :set
  end
end
