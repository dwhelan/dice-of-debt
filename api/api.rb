require 'grape'
require 'grape-roar'

module DiceOfDebt

  class API < Grape::API
    JSON_API_CONTENT_TYPE = 'application/vnd.api+json'

    format :json
    content_type :json, JSON_API_CONTENT_TYPE

    require_relative 'presenters'
    require_relative 'errors'
    require_relative 'games'

    # This should be the last route
    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end
  end
end
