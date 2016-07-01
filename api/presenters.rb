require 'roar/json'

module DiceOfDebt
  module Representer
    def self.included(base)
      base.include Roar::JSON
      base.include Grape::Roar::Representer
    end
  end

  module ResourceRepresenter
    def self.included(base)
      base.include Representer
      base.extend ClassMethods

      base.property :id, getter: ->(_) { id.to_s }
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    module ClassMethods
      def attributes(&block)
        nested(:attributes, inherit: true, &block)
      end

      def links(&block)
        nested(:links, inherit: true, &block)
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

      def as_document(resources, request)
        if resources.is_a? Array
          { 'data' => resources.map { |resource| present(resource, request) } }
        else
          { 'data' => present(resources, request) }
        end
      end

      def base_url
        'foo'
      end

      private

      def present(resource, request)
        resource.define_singleton_method(:base_url) do
          request.base_url
        end
        resource.extend(self).to_hash
      end
    end
  end
end
