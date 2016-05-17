module DiceOfDebt
  class Roll
    attr_reader :id, :rolls

    def initialize(id, rolls)
      self.id    = id
      self.rolls = rolls
    end

    private

    attr_writer :id, :rolls
  end
end
