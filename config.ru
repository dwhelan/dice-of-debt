require './domain'
require './app'
require './api'

run Rack::Cascade.new [DiceOfDebt::API, DiceOfDebt::App]
