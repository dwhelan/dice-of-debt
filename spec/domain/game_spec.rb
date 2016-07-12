require 'spec_helper'

module DiceOfDebt
  describe Game do
    let(:iteration) { subject.iteration }

    before { allow(RandomRoller).to receive(:roll) { 1 } }

    describe 'initially' do
      its(:score)      { should be 0 }
      its(:iterations) { should have(0).iterations }
    end

    specify 'roll_dice should update the score' do
      expect { subject.roll_dice }.to change { subject.score }.by 4
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

    describe 'a complete game' do
      before { 10.times { play_one_iteration } }

      it { expect(subject).to have(10).iterations }
      its(:iteration) { should be subject.iterations[9] }
      its(:score)     { should be 40 }

      it 'should fail on a roll attempt' do
        expect { subject.roll_dice }.to raise_error GameCompleteError, 'Cannot roll dice when the game is complete'
      end
    end

    def play_one_iteration
      subject.roll_dice
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
