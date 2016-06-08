module DiceOfDebt
  class Player
    attr_reader :game

    def initialize(game)
      self.game = game
    end

    def roll(fixed_rolls = {})
      game.roll(fixed_rolls).tap do
        Persistence.game_repository.save(game)
      end
    end

    private

    attr_writer :game
  end
end
