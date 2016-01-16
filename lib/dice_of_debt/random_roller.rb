class RandomRoller
  attr_accessor :sides

  def initialize(sides)
    self.sides = sides
  end

  def roll
    Random.rand(sides) + 1
  end
end
