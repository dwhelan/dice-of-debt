module DiceOfDebt
  class GamePlayer
    attr_reader :game

    def initialize(game = Persistence.game_repository.create)
      self.game = game
    end

    def roll(fixed_rolls = {})
      iteration.roll(fixed_rolls).tap do
        Persistence.iteration_repository.create(iteration)
      end
    end

    def iteration
      game.iteration
    end

    private

    attr_writer :game
  end
end
