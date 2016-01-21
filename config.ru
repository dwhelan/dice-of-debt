require './lib/dice_of_debt'
require './app'
require './api'

# use Rack::Session::Cookie
# run Rack::Cascade.new [DiceOfDebt::API, DiceOfDebt:: App]
run DiceOfDebt::API
