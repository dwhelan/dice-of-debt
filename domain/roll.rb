require 'pad'

module DiceOfDebt
  class Roll
    include Pad.entity
    attr_reader :rolls

    def initialize(id, rolls)
      self.id    = id || 1
      self.rolls = rolls
    end

    private

    attr_writer :id, :rolls
  end
end
