require 'grape'
require 'grape-roar'

module DiceOfDebt
  class API < Grape::API
    JSON_API_CONTENT_TYPE = 'application/vnd.api+json'

    format :json
    content_type :json, JSON_API_CONTENT_TYPE

    helpers do
      def find_resource(type, parameter = :id)
        id = params[parameter]
        if valid_resource_id?(id)
          error_for_invalid_resource_id(type, id, parameter)
        else
          Persistence::ROM.repository_for(type).by_id(id) || error_for_resource_not_found(type, id, parameter)
        end
      end

      def valid_resource_id?(id)
        id !~ /\d+/
      end

      def error_for_invalid_resource_id(type, id, parameter)
        error(
          status: 422,
          title: "Invalid #{type} id",
          detail: "The provided #{type} id '#{id}' should be numeric",
          source: { parameter: parameter }
        )
      end

      def error_for_resource_not_found(type, id, parameter)
        error(
          status: 404,
          title: "Could not find #{type}",
          detail: "Could not find a #{type} with id #{id}",
          source: { parameter: parameter }
        )
      end
    end
  end
end
