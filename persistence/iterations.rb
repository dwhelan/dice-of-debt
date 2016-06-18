module DiceOfDebt
  class Iterations < ROM::Relation[:sql]
    include AutoRegister

    dataset :iterations

    def by_id(id)
      where(id: id).select(:id, :game_id)
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
    relations :iterations, :games, :rolls

    def create(iteration)
      attributes = {
        value:   iteration.value,
        debt:    iteration.debt,
        status:  iteration.status.to_s,
        game_id: iteration.game.id
      }
      iteration.id = Persistence::ROM.command(:create, :iterations).call(attributes)[:id]
      Persistence::ROM.roll_repository.save(iteration.roll) if iteration.roll
      iteration
    end

    def update(iteration)
      attributes = {
        value:   iteration.value,
        debt:    iteration.debt,
        status:  iteration.status.to_s
      }
      iterations.where(id: iteration.id).update(attributes).tap do
        Persistence::ROM.roll_repository.save(iteration.roll) if iteration.roll
      end
    end

    def by_id(id)
      iterations.by_id(id).as(Iteration).one
    end
  end
end
