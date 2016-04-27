require 'dry-data'
require 'rom'
require 'rom-repository'
require 'rom-sql'

module DiceOfDebt
  # A persistence facade
  class Persistence
    def self.rom_container
      @rom_container ||= ROM.container(:sql, 'sqlite::memory') do |rom|
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

    def self.game_repository
      @game_repo ||= GameRepository.new(rom_container)
    end

    def self.connection
      rom_container.gateways[:default].connection
    end
  end

  # Retrieves games from the persistence store.
  class GameRepository < ROM::Repository
    relations :games

    def initialize(rom_container, options = {})
      super
      @rom_container = rom_container
      connection = Persistence.connection

      # TODO: move this to a migration
      connection.create_table :games do
        primary_key :id
      end

      connection[:games].insert id: '1'
    end

    def all
      games.as(Game).to_a
    end

    def with_id(id)
      games.where(id: id).as(Game).one
    end

    def create(game)
      result = @rom_container.commands[:games][:create].call(game.attributes)
      game.id = result[:id]
      game
    end

    def update(game)
      @rom_container.commands[:games][:update].call(game.attributes)
    end
  end
end
