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
end
