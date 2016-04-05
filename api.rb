require 'grape'
require 'grape-roar'

module DiceOfDebt

  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar
    # error_formatter :json, ErrorPresenter

    content_type :json, 'application/vnd.api+json'

    require_relative 'presenters'
    require_relative 'errors'
    require_relative 'games'

    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end
  end
end
