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

    def roll(roll = RandomRoller.roll(sides))
      fail ArgumentError, 'the roll must be > 0 and <= sides on a die' unless valid_roll(roll)
      self.value = roll.to_s
    end

    def valid_roll(roll)
      roll.to_i > 0 || roll.to_i <= sides
    end

    def score
      value.to_i
    end

    private

    attr_writer :value, :sides
  end
end
