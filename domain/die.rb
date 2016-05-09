module DiceOfDebt
  # The Die class encapsulates a die for game play.
  class Die
    attr_reader :value, :sides

    DEFAULTS = { sides: 6 }

    def initialize(options)
      options = DEFAULTS.merge(options)
      fail ArgumentError, 'a die must have at least one side' if options[:sides] < 1
      self.sides = options[:sides]
      self.value = 0
    end

    def roll(roll = random_roll)
      fail ArgumentError, 'the roll must be > 0 and <= sides on a die' if roll < 1 || roll > sides
      self.value = roll
    end

    private

    attr_accessor :roller
    attr_writer :value, :sides

    def random_roll
      RandomRoller.roll(sides)
    end
  end
end
