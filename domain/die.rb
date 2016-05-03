module DiceOfDebt
  # The Die class encapsulates a die for game play.
  class Die
    attr_reader :value, :sides

    def initialize(sides = 6)
      fail ArgumentError, 'a die must have at least one side' if sides < 1
      self.sides = sides
      self.value = 0
    end

    def roll(value = random_roll)
      fail ArgumentError, 'the value must be > 0 and <= sides' if value < 1 || value > sides
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
