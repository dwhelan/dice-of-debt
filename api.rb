require 'grape'

require 'rom'
require 'dry-data'
require 'rom-repository'
require 'rom-sql'

module DiceOfDebt

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

  class GameRepository < ROM::Repository
    relations :games

    def all
      games.as(Game).to_a
    end
  end
end

module DiceOfDebt
  # The API application class
  class API < Grape::API
    resource :game do
      helpers do
        def repository
          Persistence.game_repository
        end
      end

      get do
        repository.all.map {|game| game.attributes}.to_json
      end

      post do
        header 'Location', '/game/1'
        Game.new(id: 1).attributes.to_json
      end
    end
  end
end
