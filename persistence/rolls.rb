module DiceOfDebt
  module Persistence
    class Rolls < ::ROM::Relation[:sql]
      ROM.configuration.register_relation(self)

      dataset :rolls

      def by_id(id)
        where(id: id).select(:id, :iteration_id, :rolls)
      end
    end

    class RollRepository < Repository
      relations :rolls, :iterations, :games

      def create(roll)
        attributes = {
          iteration_id: roll.iteration.id,
          rolls: roll.rolls.to_json
        }
        roll.id = rolls.insert(attributes)
        roll
      end

      def update(roll)
        attributes = {
          iteration_id: roll.iteration.id,
          rolls: roll.rolls.to_json
        }
        rolls.where(id: roll.id).update(attributes)
      end

      def by_id(id)
        roll = rolls.by_id(id).combine_parents(one: iterations).one
        game = Persistence::ROM.game_repository.by_id(roll.iteration.game_id)
        iteration = game.iterations.find { |i| i.id = roll.iteration_id }
        iteration.roll
      end
    end
  end
end
