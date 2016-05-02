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

      def rom_container
        @rom_container ||= ROM.container(*configuration) do |rom|
          rom.use :macros
          rom.relation :games

          rom.commands(:games) do
            define(:create) do
              result :one
            end
            define(:update)
          end
        end
      end

      def game_repository
        @game_repo ||= GameRepository.new(rom_container)
      end

      def connection
        rom_container.gateways[:default].connection
      end
    end
  end

  # Retrieves games from the persistence store.
  class GameRepository < ROM::Repository
    relations :games

    def initialize(rom_container, options = {})
      super
      @rom_container = rom_container
    end

    def all
      games.as(Game).to_a
    end

    def with_id(id)
      games.where(id: id).as(Game).one
    end

    def create(game)
      attributes = game.attributes.reject { |key, _| key == :id }
      result = @rom_container.commands[:games][:create].call(attributes)
      game.id = result[:id]
      game
    end

    def update(game)
      @rom_container.commands[:games][:update].call(game.attributes)
    end
  end
end
