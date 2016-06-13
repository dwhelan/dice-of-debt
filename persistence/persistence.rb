require 'dry-data'
require 'rom'
require 'rom-repository'
require 'rom-sql'

module DiceOfDebt
  # A persistence facade
  class Persistence
    class << self
      attr_writer :configuration, :rom_container

      def options
        @options ||= [:sql, 'sqlite::memory']
      end

      def configuration
        @configuration ||= ROM::Configuration.new(*options)
      end

      def rom_container
        @rom_container ||= ROM.container(configuration)
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
end
