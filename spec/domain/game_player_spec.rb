require 'spec_helper'

module DiceOfDebt
  describe GamePlayer do
    before { allow(RandomRoller).to receive(:roll) { 1 } }

    describe 'roll' do
      let(:game) { Game.new }
      let(:iteration) { game.iteration }
      let(:player) { GamePlayer.new game }
      let(:repository) { Persistence.game_repository }
      let(:roll) { Roll.new(1, {}) }
      let(:rolls) { {} }

      before do
        allow(iteration).to receive(:roll).with(rolls) { roll }
      end

      it 'should roll for the current iteration' do
        player.roll(rolls)
        expect(iteration).to have_received(:roll).with(rolls)
      end

      it 'should return the roll for the current iteration' do
        expect(player.roll()).to be roll
      end

      context 'iteration complete' do
        before do
          allow(iteration).to receive(:complete?) { true }
          player.roll(rolls)
        end

        it 'should start a new iteration' do
          expect(game).to have(2).iterations
        end
      end

      context 'iteration not yet complete' do
        before do
          allow(iteration).to receive(:complete?) { false }
          player.roll(rolls)
        end

        it 'should use current iteration' do
          expect(game).to have(1).iterations
        end
      end
    end
  end
end
