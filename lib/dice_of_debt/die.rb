module DiceOfDebt
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
