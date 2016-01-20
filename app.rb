require 'sinatra'

module DiceOfDebt
  # The main web application class
  class App < Sinatra::Base
    get '/' do
      ''
    end

    post '/game' do
      response['Location'] = '/game/1'
      status 201
      game = Game.new(id: 1)
      game.attributes.to_json
    end
  end
end
