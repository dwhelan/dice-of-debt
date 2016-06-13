require 'persistent_spec_helper'

module DiceOfDebt
  describe IterationRepository do
    let(:repository) { Persistence.iteration_repository }

    before { allow(RandomRoller).to receive(:roll) { 1 } }

    specify 'create' do
      game = Persistence.game_repository.create
      iteration = Iteration.new(game: game)
      repository.create(iteration)

      created_iteration = repository.by_id iteration.id


      expect(created_iteration.id).to eq iteration.id
    end
  end
end
