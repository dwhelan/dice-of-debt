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

      def by_id(id)
        roll = rolls.by_id(id).combine_parents(one: iterations).one
        return unless roll

        game = Persistence::ROM.game_repository.by_id(roll.iteration.game_id)
        iteration = game.iterations.find { |i| i.id = roll.iteration_id }
        iteration.roll
      end

      def create(roll)
        roll.id = rolls.insert(iteration_id: roll.iteration.id, rolls: roll.rolls.to_json)
      end

      def update(roll)
        rolls.where(id: roll.id).update(rolls: roll.rolls.to_json)
      end
    end
  end
end
