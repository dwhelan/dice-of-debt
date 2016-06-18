module DiceOfDebt
  class Rolls < ROM::Relation[:sql]
    include AutoRegister

    dataset :rolls

    def by_id(id)
      where(id: id).select(:id, :iteration_id)
    end
  end

  class CreateRoll < ROM::Commands::Create[:sql]
    include AutoRegister

    register_as :create
    relation :rolls
    result :one
  end

  class UpdateRoll < ROM::Commands::Update[:sql]
    include AutoRegister

    register_as :update
    relation :rolls
  end

  class RollRepository < Repository
    relations :rolls

    def create(roll)
      attributes = {
        iteration_id: roll.iteration.id
      }
      roll.id = Persistence::ROM.command(:create, :rolls).call(attributes)[:id]
      roll
    end

    def update(roll)
      attributes = {
        iteration_id: roll.iteration.id
      }
      rolls.where(id: roll.id).update(attributes)
    end

    def by_id(id)
      rolls.by_id(id).as(Roll).one
    end
  end
end
