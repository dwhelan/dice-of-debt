require 'rake'
require 'rspec'
require 'coveralls'
require 'simplecov'
require 'rspec/its'
require 'pry-byebug'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]
SimpleCov.start

Coveralls.wear! if Coveralls.will_run?

Dir['./spec/shared/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    load './Rakefile'
    Rake::Task['db:migrate'].invoke
    # `rake db:migrate`
  end
end

require_relative '../domain'

DiceOfDebt::Persistence.configuration = [:sql, 'sqlite::memory']
