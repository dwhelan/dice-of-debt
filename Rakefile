require 'pry-byebug'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require_relative 'domain'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: [:spec, :rubocop]

require 'rom'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    DiceOfDebt::Persistence.rom_container
  end
end
