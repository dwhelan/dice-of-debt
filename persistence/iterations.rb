module DiceOfDebt
  module Persistence
    class Iterations < ::ROM::Relation[:sql]
      ROM.configuration.register_relation(self)

      dataset :iterations

      def by_game_id(game_id)
        where(game_id: game_id).select(:id, :game_id, :value, :debt, :status)
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
      end

      def update(iteration)
        attributes = {
          value:   iteration.value,
          debt:    iteration.debt,
          status:  iteration.status.to_s
        }
        iterations.where(id: iteration.id).update(attributes)
      end
    end
  end
end
