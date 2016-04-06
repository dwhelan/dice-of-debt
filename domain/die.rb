module DiceOfDebt
  # The Die class encapsulates a die for game play.
  class Die
    attr_accessor :roller

    def initialize(options)
      self.roller = options.roller
    end

    def roll
      roller.roll
    end
  end
end
