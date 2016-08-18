require 'persistent_spec_helper'

module DiceOfDebt
  describe Player do
    before { allow(RandomRoller).to receive(:roll) { 1 } }

    describe 'roll' do
      let(:game)   { Game.new }
      let(:player) { Player.new game }
      let(:roll)   { Roll.new }
      let(:rolls)  { {} }

      before do
        allow(game).to receive(:roll_dice) { roll }
        allow(Persistence::ROM.game_repository).to receive(:save)
      end

      it 'should default roll to be an empty hash' do
        player.roll_dice
        expect(game).to have_received(:roll_dice).with({})
      end

      it 'should send roll to the game' do
        player.roll_dice(rolls)
        expect(game).to have_received(:roll_dice).with(rolls)
      end

      it 'should return the roll from the game' do
        expect(player.roll_dice).to be roll
      end

      it 'should end the iteration' do
        iteration = game.iteration
        expect { player.roll_dice }.to change { iteration.complete? }.from(false).to(true)
      end

      it 'should save the game' do
        player.roll_dice
        expect(Persistence::ROM.game_repository).to have_received(:save).with(game)
      end
    end
  end
end
