module DiceOfDebt
  module Persistence
    class Iterations < ::ROM::Relation[:sql]
      include AutoRegister

      dataset :iterations

      def by_game_id(game_id)
        where(game_id: game_id).select(:id, :game_id, :value, :debt)
      end
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
        iteration.id = iterations.insert(attributes)
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
    end
  end
end
