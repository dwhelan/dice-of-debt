require 'dry-data'
require 'rom'
require 'rom-repository'
require 'rom-sql'

module DiceOfDebt
  # A persistence facade
  class Persistence
    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= [:sql, 'postgres://localhost/dice_of_debt']
      end

      # rubocop:disable Metrics/MethodLength
      def rom_container
        @rom_container ||= ROM.container(*configuration) do |rom|
          rom.use :macros

          rom.relation :iterations
          rom.relation :games

          rom.commands(:games) do
            define(:create)
            define(:update)
          end

          rom.commands(:iterations) do
            define(:create)
            define(:update)
          end
        end
      end

      def game_repository
        @game_repo ||= GameRepository.new(rom_container)
      end

      def iteration_repository
        @iteration_repo ||= IterationRepository.new(rom_container)
      end

      def connection
        rom_container.gateways[:default].connection
      end
    end
  end

  class Repository < ROM::Repository
    def initialize(rom_container, options = {})
      super
      @rom_container = rom_container
    end

    def command(operation, relation)
      @rom_container.commands[relation][operation]
    end

    def save(object)
      object.id ? update(object) : create(object)
    end

    def update(object)
      attributes = object.attributes.reject { |k, _| k == :id }
      command(:update, self.class.relations.first).call(attributes)
    end
  end

  class IterationRepository < Repository
    relations :iterations

    def create(iteration)
      attributes = iteration.attributes.reject { |k, _| k == :id }.merge(game_id: iteration.game.id)
      iteration.id = command(:create, :iterations).call(attributes).first[:id]
      iteration
    end

    def for_game(game)
      result = iterations.where(game_id: game.id).as(Iteration).to_a
      result.each { |iteration| iteration.game = game }
      result
    end
  end

  # Retrieves games from the persistence store.
  class GameRepository < Repository
    relations :games, :iterations

    def create(game = Game.new)
      game.id = command(:create, :games).call({}).first[:id]
      game
    end

    def update(game)
      games.where(id: game.id).update(score: game.score)
      Persistence.iteration_repository.save(game.iterations.last)
    end

    def all
      games.as(Game).to_a.tap do |all_games|
        all_games.each do |game|
          game.iterations = Persistence.iteration_repository.for_game(game)
        end
      end
    end

    def with_id(id)
      game = games.where(id: id).as(Game).one
      game.iterations = Persistence.iteration_repository.for_game(game) if game
      game
    end
  end
end
