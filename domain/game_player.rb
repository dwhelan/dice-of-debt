module DiceOfDebt
  class GamePlayer
    attr_reader :game

    def initialize(game)
      self.game = game
    end

    def roll(fixed_rolls = {})
      iteration.roll(fixed_rolls).tap do
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
