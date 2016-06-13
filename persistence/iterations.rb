module DiceOfDebt
  class Iterations < ROM::Relation[:sql]
    include AutoRegister

    dataset :iterations

    view(:by_id, [:id, :game_id]) do |id|
      where(id: id).select(:id, :game_id)
    end

    view(:by_game_id, [:id, :game_id]) do |game_id|
      where(game_id: game_id).select(:id, :game_id)
    end
  end

  class CreateIteration < ROM::Commands::Create[:sql]
    include AutoRegister

    register_as :create
    relation :iterations
    result :one
  end

  class UpdateIteration < ROM::Commands::Update[:sql]
    include AutoRegister

    register_as :update
    relation :iterations
  end

  class IterationRepository < Repository
    relations :iterations, :games

    def create(iteration)
      attributes = {
        value:   iteration.value,
        debt:    iteration.debt,
        status:  iteration.status.to_s,
        game_id: iteration.game.id
      }
      iteration.id = command(:create, :iterations).call(attributes)[:id]
      iteration
    end

    def by_id(id)
      iterations.by_id(id).as(Iteration).one
    end

    def by_game(game)
      iterations.by_game_id(game.id).as(Iteration).to_a.tap do |game_iterations|
        game_iterations.each { |iteration| iteration.game = game }
      end
    end
  end
end
