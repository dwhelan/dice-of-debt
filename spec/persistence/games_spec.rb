require 'persistent_spec_helper'

module DiceOfDebt
  describe GameRepository do
    subject { Persistence::ROM.game_repository }

    before :all do
      insert_data :games, id: 41, score: 98
      insert_data :games, id: 42, score: 99
      insert_data :games, id: 43, score: 100

      insert_data :iterations, id: 420, game_id: 42
      insert_data :iterations, id: 421, game_id: 42
    end

    after :all do
      delete_data :iterations, game_id: [41, 42, 43]
      delete_data :games, id: [41, 42, 43]
    end

    describe 'by_id' do
      specify 'with bad id' do
        expect(subject.by_id 999).to be_nil
      end

      specify 'with no iterations' do
        game = subject.by_id 41
        expect(game.attributes).to include(id: 41, score: 98)
        expect(game.iterations).to be_empty
      end

      specify 'with iterations' do
        game = subject.by_id 42
        expect(game.attributes).to include(id: 42, score: 99)
        expect(game.iterations.count).to eq 2
        expect(game.iterations[0].attributes).to include(id: 420, game: game)
        expect(game.iterations[1].attributes).to include(id: 421, game: game)
      end
    end

    describe 'all' do
      specify 'game with no iterations' do
        game = subject.all.find { |g| g.id == 41 }
        expect(game.attributes).to include(id: 41)
        expect(game.iterations).to be_empty
      end

      specify 'with iterations' do
        game = subject.all.find { |g| g.id == 42 }
        expect(game.attributes).to include(id: 42)
        expect(game.iterations).to be_empty
      end
    end

    specify 'create' do
      game = subject.create
      expect(game.id).to be > 0
      expect(game.score).to eq 0
    end

    describe 'update' do
      let(:game)      { subject.by_id 43 }
      let(:iteration) { game.iteration   }

      specify 'with no iterations' do
        game.score = 123
        subject.update game
        expect(subject.by_id(43).score).to eq 123
      end

      specify 'should save iteration with a single iteration' do
        game.score = 124
        expect(Persistence::ROM.iteration_repository).to receive(:save).with(game.iteration)

        subject.update game

        expect(subject.by_id(43).score).to eq 124
      end

      specify 'should save last iteration with multiple iterations' do
        game.score = 125
        game.end_iteration
        game.end_iteration
        expect(Persistence::ROM.iteration_repository).to receive(:save).with(game.iterations.last)
        expect(Persistence::ROM.iteration_repository).not_to receive(:save).with(game.iterations.first)

        subject.update game

        expect(subject.by_id(43).score).to eq 125
      end
    end
  end
end
