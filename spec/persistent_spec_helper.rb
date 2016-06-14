require 'spec_helper'

require_relative '../persistence/configuration'

DiceOfDebt::Persistence::Configuration.config do |config|
  config.database_uri = 'sqlite::memory'
  config.options      = { logger: Logger.new(File.open('./tmp/test.log', 'w')) }
end

require_relative '../persistence'

RSpec.configure do |config|
  config.before :suite do
    load './Rakefile'
    Rake::Task['db:migrate'].invoke
  end
end
