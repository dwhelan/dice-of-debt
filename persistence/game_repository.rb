# Retrieves games from the persistence store.

module DiceOfDebt
  class GameRepository < Repository
    relations :games

    def create(game = Game.new)
      game.id = command(:create, :games).call({}).first[:id]
      game
    end

    def update(game)
      games.where(id: game.id).update(score: game.score)
      Persistence.iteration_repository.save(game.iterations.last)
    end

    def all
      games.as(Game).to_a.tap do |all_games|
        all_games.each do |game|
          game.iterations = iterations_for_game(game)
        end
      end
    end

    def with_id(id)
      games.where(id: id).as(Game).one.tap do |game|
        game.iterations = iterations_for_game(game) if game
      end
    end

    private

    def iterations_for_game(game)
      Persistence.iteration_repository.for_game(game)
    end
  end
end
