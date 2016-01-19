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
      '/game/1'
    end
  end
end
