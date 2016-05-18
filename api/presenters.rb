require 'roar/json'

module DiceOfDebt
  module Presenter
    def self.included(base)
      base.include Roar::JSON
      base.include Grape::Roar::Representer
    end
  end

  module DocumentPresenter

  end

  module ResourcePresenter
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    module ClassMethods
      def attributes(&block)
        nested(:attributes, inherit: true, &block)
      end

      def relationships(&block)
        nested(:relationships, inherit: true, &block)

        class_eval do
          define_method :to_hash do |*args|
            hash = super(*args)

            data = hash['data'] || hash
            if data
              data['included'] = data['relationships'].values.flatten
              data['relationships'] = data['relationships'].map do |name, relationship|
                [name, data: relationship_data(relationship)]
              end.to_h
            end

            hash
          end

          define_method :relationship_data do |relationship|
            if relationship.is_a? Array
              relationship.map { |r| relationship_data(r) }
            else
              { 'id' => relationship['id'], 'type' => relationship['type'] }
            end
          end
        end
      end

      def type(type)
        property :type, getter: ->(_) { type }
      end

      def resource_presenter(presenter)
        self.representation_wrap = :data
        include presenter
      end

    end

    def self.included(base)
      base.include Presenter
      base.extend ClassMethods

      # document_module = Module.new do
      #   include Presenter
      #
      #   self.representation_wrap = :data
      # end
      #
      # base.const_set(:Document, document_module)

      base.property :id, getter: ->(_) { id.to_s }

      # def base.attributes(&block)
      #   nested(:attributes, inherit: true, &block)
      # end

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
