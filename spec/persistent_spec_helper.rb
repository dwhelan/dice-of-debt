require 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    load './Rakefile'
    Rake::Task['db:migrate'].invoke
    #
    # require 'sequel/database'
    # require 'logger'
    # DB.loggers << Logger.new($stdout)
  end
end

DiceOfDebt::Persistence.database_uri = 'sqlite::memory'
