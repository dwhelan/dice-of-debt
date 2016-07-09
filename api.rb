require 'grape'
require 'grape-roar'

module DiceOfDebt
  class API < Grape::API
    JSON_API_CONTENT_TYPE = 'application/vnd.api+json'

    format :json
    content_type :json, JSON_API_CONTENT_TYPE

    require_relative 'api/presenters'

    require_relative 'api/root'
    require_relative 'api/errors'
    require_relative 'api/iterations'
    require_relative 'api/rolls'
    require_relative 'api/games'
    require_relative 'api/swagger_doc'

    # This should follow all resource routes to enable CORS
    require_relative 'api/cors'

    # This should be the last route as it will match any path
    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end

    helpers do
      def find_resource(type, id)
        if valid_resource_id?(id)
          error_for_invalid_resource_id(type, id)
        else
          Persistence::ROM.repository_for(type).by_id(id) || error_for_resource_not_found(type, id)
        end
      end

      def valid_resource_id?(id)
        id !~ /\d+/
      end

      def error_for_invalid_resource_id(type, id)
        error(
          status: 422,
          title: "Invalid #{type} id",
          detail: "The provided #{type} id '#{id}' should be numeric",
          source: { parameter: :id }
        )
      end

      def error_for_resource_not_found(type, id)
        error(
          status: 404,
          title: "Could not find #{type}",
          detail: "Could not find a #{type} with id #{id}",
          source: { parameter: :id }
        )
      end
    end
  end
end
