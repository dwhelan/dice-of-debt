require './domain'
require './api'
require 'pry-byebug' if ENV['RACK_ENV'] != 'production'

run Rack::Cascade.new [DiceOfDebt::API]
