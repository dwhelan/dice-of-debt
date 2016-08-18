require_relative 'domain/random_roller'
require_relative 'domain/die'
require_relative 'domain/dice'
require_relative 'domain/dice_set'
require_relative 'domain/roll'
require_relative 'domain/iteration'
require_relative 'domain/game'
require_relative 'domain/player.rb'

module DiceOfDebt
  class GameCompleteError < StandardError; end
end
