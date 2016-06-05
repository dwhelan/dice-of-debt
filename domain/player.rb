module DiceOfDebt
  class Player
    attr_reader :game

    def initialize(game)
      self.game = game
    end

    def roll(fixed_rolls = {})
      game.roll(fixed_rolls).tap do
        Persistence.game_repository.save(game)
        Persistence.iteration_repository.save(iteration)
      end
    end

    def iteration
      game.iteration
    end

    private

    attr_writer :game
  end
end
