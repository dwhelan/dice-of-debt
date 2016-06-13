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

    specify 'end() should complete the iteration' do
      subject.end
      expect(subject).to be_complete
    end

    describe 'roll' do
      it { expect(subject.roll).to be_a Roll }
      it { expect(subject.roll.rolls).to eq value: [1, 1, 1, 1, 1, 1, 1, 1], debt: [1, 1, 1, 1] }
    end

    describe 'rolling' do
      before { subject.roll }

      its(:value) { should be 8 }
      its(:debt)  { should be 4 }
      its(:score) { should be 4 }
    end
  end
end
