require 'persistent_spec_helper'

module DiceOfDebt
  describe IterationRepository do
    let(:repository) { Persistence::ROM.iteration_repository }

    before { allow(RandomRoller).to receive(:roll) { 1 } }

    specify 'create' do
      game = Persistence::ROM.game_repository.create
      iteration = Iteration.new(game: game)

      expect(Persistence::ROM.roll_repository).to_not receive :save
      repository.create(iteration)

      created_iteration = Persistence::ROM.game_repository.by_id(game.id).iterations.first
      expect(created_iteration.id).to eq iteration.id
    end

    specify 'update' do
      game = Persistence::ROM.game_repository.create
      iteration = Iteration.new(game: game)
      repository.create(iteration)
      roll = iteration.roll_dice
      expect(Persistence::ROM.roll_repository).to receive(:save).with(roll)

      repository.update(iteration)
    end
  end
end
