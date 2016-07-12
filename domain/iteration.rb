require 'pad'

module DiceOfDebt
  # Define empty Game to allow Virtus attribute to reference it
  # TODO: try using Virtus finalization
  class Game
  end

  # The Iteration class is responsible for keeping track of the value, debt and overall score for each iteration.
  class Iteration
    include Pad.entity
    attr_reader :value, :debt

    attribute :game,   Game
    attribute :value,  Integer, default: 0
    attribute :debt,   Integer, default: 0
    attribute :status, Symbol,  default: :started
    attribute :roll,   Roll

    def roll_dice(fixed_rolls = {})
      dice.roll(fixed_rolls).tap do
        self.value = dice[:value].score
        self.debt  = dice[:debt].score
      end
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
  end
end
