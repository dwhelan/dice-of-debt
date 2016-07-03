require 'spec_helper'

module DiceOfDebt
  describe Iteration do
    before { allow(RandomRoller).to receive(:roll) { 1 } }
    subject { Iteration.new(game: Game.new) }

    describe 'initially' do
      its(:score) { should be 0 }
      its(:debt)  { should be 0 }
      its(:score) { should be 0 }
      it { should_not be_complete }
    end

    specify 'should be able to end the iteration' do
      subject.end
      expect(subject).to be_complete
    end

    describe 'roll_dice' do
      it 'should send fixed_roll to the dice' do
        fixed_rolls = {}
        roll = {}
        expect(subject.dice).to receive(:roll).with(fixed_rolls) { roll }
        rolled_dice = subject.roll_dice(fixed_rolls)
        expect(rolled_dice).to be_a Roll
        expect(rolled_dice.rolls).to be roll
      end

      it 'should send an empty hash to the dice' do
        roll = {}
        expect(subject.dice).to receive(:roll).with({}) { roll }
        rolled_dice = subject.roll_dice
        expect(rolled_dice).to be_a Roll
        expect(rolled_dice.rolls).to be roll
      end

      it { expect { subject.roll_dice }.to change { subject.value }.by 8 }
      it { expect { subject.roll_dice }.to change { subject.debt  }.by 4 }
      it { expect { subject.roll_dice }.to change { subject.score }.by 4 }
    end

    describe 'roll_dice' do
      it { expect(subject.roll_dice).to be_a Roll }
      it { expect(subject.roll_dice.rolls).to eq value: [1, 1, 1, 1, 1, 1, 1, 1], debt: [1, 1, 1, 1] }
    end

    describe 'rolling' do
      before { subject.roll_dice }

      its(:value) { should be 8 }
      its(:debt)  { should be 4 }
      its(:score) { should be 4 }
    end
  end
end
