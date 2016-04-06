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
        end
      end
    end

    def self.game_repository
      GameRepository.new(rom_container)
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
  end
end
