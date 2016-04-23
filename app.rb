require 'sinatra'

module DiceOfDebt
  # The web application class
  class App < Sinatra::Base
    set :allow_origin, :any
    enable :cross_origin

    get '/' do
      ''
    end
  end
end
