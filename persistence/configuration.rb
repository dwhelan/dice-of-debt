module DiceOfDebt
  module Persistence
    class Configuration
      class << self
        def database_uri
          @database_uri ||= 'postgres://localhost/dice_of_debt'
        end

        def database_uri=(uri)
          fail 'Cannot set the database URI when it has already been set' if @database_uri
          @database_uri = uri
        end

        def options
          @options ||= {}
        end

        def options=(opts)
          fail 'Cannot set options when they have already been set' if @options
          @options = opts
        end

        def config
          yield self if block_given?
          self
        end
      end
    end
  end
end
