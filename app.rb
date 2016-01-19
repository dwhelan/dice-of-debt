require 'sinatra'

module DiceOfDebt
  # The main web application class
  class App < Sinatra::Base
    get '/' do
      ''
    end

    post '/games' do
      game = Game.new
      status 201
      game.to_json
    end
  end
end
