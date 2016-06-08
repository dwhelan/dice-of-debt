require 'spec_helper'

module DiceOfDebt
  describe Game do
    before { allow(RandomRoller).to receive(:roll) { 1 } }

    describe 'initially' do
      its(:score)      { should be 0 }
      its(:iterations) { should have(0).iterations }
    end

    describe 'roll' do
      it { expect(subject.roll).to be_a Roll }
      it { expect(subject.roll.rolls).to eq value: [1, 1, 1, 1, 1, 1, 1, 1], debt: [1, 1, 1, 1] }
    end

    describe 'iteration' do
      it 'initially should not be complete' do
        expect(subject.iteration).to_not be_complete
      end

      it 'should use iteration when last one not complete' do
        allow(subject.iteration).to receive(:complete?) { false }
        subject.iteration
        expect(subject).to have(1).iterations
      end

      it 'should create a new iteration when last one complete' do
        allow(subject.iteration).to receive(:complete?) { true }
        subject.iteration
        expect(subject).to have(2).iterations
      end
    end

    describe 'rolling' do
      before { subject.roll }

      its(:'iteration.value') { should be 8 }
      its(:'iteration.debt')  { should be 4 }
      its(:'iteration.score') { should be 4 }
      its(:score)             { should be 4 }
    end

    describe 'after 10 iterations' do
      before { 10.times { play_one_iteration } }

      its(:iteration) { should be subject.iterations[9] }
      its(:score)     { should be 40 }
    end

    def play_one_iteration
      subject.roll
      subject.end_iteration
    end

    specify 'config' do
      expect(subject.config).to eq(
        dice: {
          value: { count: 8, sides: 6 },
          debt:  { count: 4, sides: 6 }
        },
        iterations: 10
      )
    end
  end
end
