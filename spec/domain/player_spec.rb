require 'spec_helper'

module DiceOfDebt
  describe Player do
    before { allow(RandomRoller).to receive(:roll) { 1 } }

    describe 'roll' do
      let(:game)   { Game.new }
      let(:player) { Player.new game }
      let(:roll)   { Roll.new(1, {}) }
      let(:rolls)  { {} }

      before do
        allow(game).to receive(:roll) { roll }
        allow(Persistence.game_repository).to receive(:save)
      end

      it 'should default roll to be an empty hash' do
        player.roll
        expect(game).to have_received(:roll).with({})
      end

      it 'should send roll to the game' do
        player.roll(rolls)
        expect(game).to have_received(:roll).with(rolls)
      end

      it 'should return the roll from the game' do
        expect(player.roll).to be roll
      end

      it 'should save the game' do
        player.roll
        expect(Persistence.game_repository).to have_received(:save).with(game)
      end
    end
  end
end
