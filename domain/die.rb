module DiceOfDebt
  # The Die class encapsulates a die for game play.
  class Die
    attr_reader :value

    def initialize(roller)
      self.roller = roller
    end

    def roll(value = roller.roll)
      self.value = value
    end

    private

    attr_accessor :roller
    attr_writer :value
  end
end
