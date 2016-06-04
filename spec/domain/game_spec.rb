require 'spec_helper'

module DiceOfDebt
  describe Game do
    before { allow(RandomRoller).to receive(:roll) { 1 } }

    describe 'initially' do
      its(:score)      { should be 0 }
      its(:iterations) { should have(0).iterations }
    end

    describe 'roll' do
      subject { Game.new.iteration.roll }

      it { should be_a Roll }
      its(:rolls) { should eq value: [1, 1, 1, 1, 1, 1, 1, 1], debt: [1, 1, 1, 1] }
    end

    describe 'first iteration' do
      describe 'rolling' do
        before { subject.iteration.roll }

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

      describe 'after 11 iterations' do
        before { 11.times { play_one_iteration } }

        its(:iteration) { should be subject.iterations[9] }
        its(:score)     { should be 40 }
      end

      def play_one_iteration
        subject.iteration.roll
        subject.end_iteration
      end
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
