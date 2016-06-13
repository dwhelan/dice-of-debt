require 'dry-data'
require 'rom'
require 'rom-repository'
require 'rom-sql'

module DiceOfDebt
  # A persistence facade
  class Persistence
    class << self
      def options
        @options ||= [:sql, 'sqlite::memory']
      end

      def configuration
        @configuration ||= ROM::Configuration.new(*options)
      end

      def rom
        @rom ||= ROM.container(configuration)
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

      def connection
        rom.gateways[:default].connection
      end
    end
  end
end
