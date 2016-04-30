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
    require_relative 'api/games'
    require_relative 'api/swagger_docs'

    # This should follow all resource routes to enable CORS
    require_relative 'api/cors'

    # This should be the last route as it will match any path
    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end

    puts routes
  end
end
