module DiceOfDebt
  # The Die class encapsulates a die for game play.
  class Die
    attr_reader :value, :sides

    DEFAULTS = { sides: 6 }

    def initialize(options)
      options = DEFAULTS.merge(options.to_h)
      fail ArgumentError, 'a die must have at least one side' if options[:sides] < 1
      self.sides = options[:sides]
      self.value = 0
    end

    def roll(value = random_roll)
      fail ArgumentError, 'the value rolled must be > 0 and <= sides on a die' if value < 1 || value > sides
      self.value = value
    end

    def random_roll
      Random.rand(sides) + 1
    end

    private

    attr_accessor :roller
    attr_writer :value, :sides
  end
end
