require 'pad'

module DiceOfDebt
  # The Iteration class is responsible for keeping track of the value, debt and overall score for each iteration.
  class Iteration
    include Pad.entity
    attr_reader :value, :debt
    attr_accessor :game

    def initialize(game)
      self.game   = game
      self.debt   = 0
      self.value  = 0
      self.status = :started
    end

    def roll(fixed_rolls = {})
      rolls = dice.roll(fixed_rolls).tap do
        self.value = dice[:value].value
        self.debt  = dice[:debt].value
      end
      Roll.new(id, rolls)
    end

    def score
      value - debt
    end

    def end
      self.status = :complete
    end

    def complete?
      status == :complete
    end

    def dice
      game.dice
    end

    private

    attr_writer :value, :debt
    attr_accessor :status
  end
end
