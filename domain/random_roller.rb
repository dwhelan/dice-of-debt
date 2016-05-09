module DiceOfDebt
  class RandomRoller
    def self.roll(sides)
      Random.rand(sides) + 1
    end
  end
end
