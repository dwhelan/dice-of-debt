require './domain'
require './api'

run Rack::Cascade.new [DiceOfDebt::API]
