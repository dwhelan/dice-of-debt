require 'grape'
require 'grape-roar'

module DiceOfDebt

  class API < Grape::API

    JSON_API_CONTENT_TYPE = 'application/vnd.api+json'

    format :json
    content_type :json, JSON_API_CONTENT_TYPE

    require_relative 'api/presenters'
    require_relative 'api/errors'
    require_relative 'api/games'

    resource '/' do
      get do
        { foo: :bar }
      end
    end

    require 'grape-cors'

    Grape::CORS::Config.methods.clear
    Grape::CORS::Config.methods.push 'HEAD', 'OPTIONS', 'GET', 'POST', 'PATCH', 'DELETE'

    Grape::CORS.apply!

    # This should be the last route
    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end

  end

end
