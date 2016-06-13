# Retrieves games from the persistence store.

module DiceOfDebt

  class Games < ROM::Relation[:sql]
    dataset :games

    view(:by_id, [:id, :score]) do |id|
      where(id: id).select(:id, :score)
    end
  end

  class Iterations < ROM::Relation[:sql]
    dataset :iterations

    view(:by_id, [:id, :game_id]) do |id|
      where(id: id).select(:id, :game_id)
    end

    view(:by_game_id, [:id, :game_id]) do |game_id|
      where(game_id: game_id).select(:id, :game_id)
    end
  end

  class CreateGame < ROM::Commands::Create[:sql]
    register_as :create
    relation :games
    result :one
  end

  class UpdateGame < ROM::Commands::Update[:sql]
    register_as :update
    relation :games
    result :one
  end

  class CreateIteration < ROM::Commands::Create[:sql]
    register_as :create
    relation :iterations
  end

  class UpdateIteration < ROM::Commands::Update[:sql]
    register_as :update
    relation :iterations
  end

  config = Persistence.configuration
  config.register_relation(Games)
  config.register_command(CreateGame, UpdateGame)

  config.register_relation(Iterations)
  config.register_command(CreateIteration, UpdateIteration)

  class GameRepository < Repository
    relations :games, :iterations

    def by_id(id)
      if attributes = games.by_id(id).combine_children(many: iterations).one
        game_from_attributes(attributes)
      end
    end

    def all
      games.combine_children(many: iterations).to_a.map do |attributes|
        game_from_attributes(attributes)
      end
    end

    def create
      Game.new.tap do |game|
        game.id = command(:create, :games).call({})[:id]
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
