require 'roar/json'

module DiceOfDebt
  module Presenter
    def self.included(base)
      base.include Roar::JSON
      base.include Grape::Roar::Representer
    end
  end

  module ResourcePresenter
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def self.included(base)
      base.include Presenter

      base.property :id, getter: ->(_) { id.to_s }

      def base.attributes(&block)
        nested(:attributes, inherit: true, &block)
      end

      # rubocop:disable Lint/NestedMethodDefinition
      def base.includes(&block)
        nested(:included, inherit: true, &block)

        class_eval do
          # TODO: Fix hack below that enforces that "included" is an array. Could this be done in representer instead?
          def to_hash(*args)
            h = super
            h['data']['included'] = h['data']['included'].values.flatten if h['data'] && h['data']['included']
            h
          end
        end
      end

      def base.type(type)
        property :type, getter: ->(_) { type }
      end

      def base.resource_presenter(presenter)
        self.representation_wrap = :data
        include presenter
      end
    end
  end

  module ResourceArrayPresenter
    def self.included(base)
      base.include Presenter

      def base.resource_presenter(presenter)
        collection :entries, as: 'data', extend: presenter, embedded: true
      end
    end
  end
end
