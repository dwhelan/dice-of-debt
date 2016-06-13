# Retrieves games from the persistence store.

module DiceOfDebt
  class Games < ROM::Relation[:sql]
    include AutoRegister

    dataset :games

    def by_id(id)
      where(id: id).select(:id, :score)
    end
  end

  class CreateGame < ROM::Commands::Create[:sql]
    include AutoRegister

    register_as :create
    relation :games
    result :one
  end

  class UpdateGame < ROM::Commands::Update[:sql]
    include AutoRegister

    register_as :update
    relation :games
  end

  class GameRepository < Repository
    relations :games, :iterations

    def by_id(id)
      attributes = games.by_id(id).combine_children(many: iterations).one
      game_from_attributes(attributes) if attributes
    end

    def all
      games.combine_children(many: iterations).to_a.map do |attributes|
        game_from_attributes(attributes)
      end
    end

    def create
      Game.new.tap do |game|
        game.id = Persistence.command(:create, :games).call({})[:id]
      end
    end

    def update(game)
      games.where(id: game.id).update(score: game.score).tap do
        Persistence.iteration_repository.save(game.iterations.last)
      end
    end

    private

    def game_from_attributes(attributes)
      Game.new(attributes).tap do |game|
        game.iterations = game.iterations.map do |iteration_attributes|
          Iteration.new(iteration_attributes.to_h.merge(game: game))
        end
      end
    end
  end
end
