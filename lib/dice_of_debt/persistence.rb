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

    def all
      games.as(Game).to_a
    end

    def with_id(id)
      games.where(id: id).as(Game).one
    end
  end
end
