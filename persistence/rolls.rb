module DiceOfDebt
  module Persistence
    class Rolls < ::ROM::Relation[:sql]
      ROM.configuration.register_relation(self)

      dataset :rolls

      def by_id(id)
        where(id: id).select(:id, :iteration_id, :game_id, :rolls)
      end
    end

    class RollRepository < Repository
      relations :rolls, :iterations, :games

      def by_id(id)
        roll_data = rolls.by_id(id).combine_parents(one: games).one
        return unless roll_data

        Roll.new(roll_data).tap do |roll|
          roll.game = Persistence::ROM.game_repository.by_id(roll_data.game_id) if roll
        end
      end

      def create(roll)
        roll.id = rolls.insert(iteration_id: roll.iteration.id, game_id: roll.game.id, rolls: roll.rolls.to_json)
      end

      def update(roll)
        rolls.where(id: roll.id).update(rolls: roll.rolls.to_json)
      end
    end
  end
end
