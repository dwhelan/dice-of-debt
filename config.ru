require './domain'
require './app'
require './api'

# use Rack::Session::Cookie
run Rack::Cascade.new [DiceOfDebt::API, DiceOfDebt::App]
