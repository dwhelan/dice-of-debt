require 'roar/json'

module DiceOfDebt
  module Presenter
    def self.included(base)
      base.include Roar::JSON
      base.include Grape::Roar::Representer
    end
  end

  module ResourcePresenter
    # rubocop:disable Metrics/MethodLength
    def self.included(base)
      base.include Presenter

      base.property :id, getter: ->(_) { id.to_s }

      def base.attributes(&block)
        nested(:attributes, inherit: true, &block)
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
