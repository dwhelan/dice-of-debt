require 'rom'
require 'rom-repository'
require 'rom-sql'

module DiceOfDebt
  # A persistence facade
  module Persistence
    class ROM
      class << self
        def configuration
          @configuration ||= ::ROM::Configuration.new(:sql, Configuration.database_uri, Configuration.options)
        end

        def rom
          @rom ||= ::ROM.container(configuration)
        end

        def connection
          rom.gateways[:default].connection
        end

        def command(operation, relation)
          rom.commands[relation][operation]
        end

        def game_repository
          @game_repository ||= GameRepository.new(rom)
        end

        def iteration_repository
          @iteration_repository ||= IterationRepository.new(rom)
        end

        def roll_repository
          @roll_repository ||= RollRepository.new(rom)
        end
      end
    end
  end
end
