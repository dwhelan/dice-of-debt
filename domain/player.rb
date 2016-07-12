module DiceOfDebt
  class Player
    attr_reader :game

    def initialize(game)
      self.game = game
    end

    # rubocop:disable Metrics/AbcSize
    def roll_dice(fixed_rolls = {})
      game.roll_dice(fixed_rolls).tap do |roll|
        game.iteration.end
        roll.game = game
        roll.iteration = game.iterations.last

        Persistence::ROM.game_repository.save(game)
        Persistence::ROM.roll_repository.save(roll)
      end
    end

    private

    attr_writer :game
  end
end
