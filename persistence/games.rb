# Retrieves games from the persistence store.

module DiceOfDebt
  module Persistence
    class Games < ::ROM::Relation[:sql]
      ROM.configuration.register_relation(self)

      dataset :games

      def by_id(id)
        where(id: id).select(:id, :score)
      end
    end

    class GameRepository < Repository
      relations :games, :iterations, :rolls

      def by_id(id)
        game = games.by_id(id).as(Game).one
        return unless game

        game.iterations = iterations.by_game_id(id).combine_children(one: rolls).as(Iteration).to_a
        game.iterations.each do |iteration|
          iteration.game = game
          iteration.roll.iteration = iteration if iteration.roll
        end
        game
      end

      def all
        games.as(Game).to_a
      end

      def create
        Game.new.tap do |game|
          game.id = games.insert(score: game.score)
        end
      end

      def update(game)
        games.where(id: game.id).update(score: game.score).tap do
          Persistence::ROM.iteration_repository.save(game.iterations.last)
        end
      end
    end
  end
end
