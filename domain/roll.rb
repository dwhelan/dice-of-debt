module DiceOfDebt
  class Roll
    attr_reader :id, :rolls

    def initialize(game, rolls)
      self.id = game.iterations.count
      self.rolls = rolls
    end

    private

    attr_writer :id, :rolls
  end
end
