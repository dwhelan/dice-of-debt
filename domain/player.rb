module DiceOfDebt
  class Player
    attr_reader :game

    def initialize(game)
      self.game = game
    end

    def roll_dice(fixed_rolls = {})
      game.roll_dice(fixed_rolls).tap do
        game.iteration.end
        Persistence::ROM.game_repository.save(game)
      end
    end

    private

    attr_writer :game
  end
end
