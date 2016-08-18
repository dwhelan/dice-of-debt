require 'logger'
require_relative './persistence/configuration'

Dir.mkdir './tmp' unless Dir.exist? './tmp'
log_file = File.open('./tmp/production.log', 'w')
log_file.sync = true

DiceOfDebt::Persistence::Configuration.config do |config|
  config.database_uri = 'postgres://localhost/dice_of_debt'
  config.options      = { logger: Logger.new(log_file) }
end

require './domain'
require './persistence'
require './api'
require 'pry-byebug' if ENV['RACK_ENV'] != 'production'

run Rack::Cascade.new [DiceOfDebt::API]
