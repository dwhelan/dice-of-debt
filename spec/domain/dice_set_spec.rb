require 'spec_helper'

module DiceOfDebt
  describe DiceSet do
    before { allow(RandomRoller).to receive(:roll) { 6 } }

    context 'empty set' do
      subject { DiceSet.new }

      describe 'empty set rolls should always return an empty hash' do
        it { expect(subject.roll).to eq({}) }
        it { expect(subject.roll({})).to eq({}) }
        it { expect(subject.roll(dice: [])).to eq({}) }
        it { expect(subject.roll(dice: [1])).to eq({}) }
        it { expect(subject.roll(dice: [1, 2], second: [1])).to eq({}) }
      end
    end

    context 'set of one' do
      subject { DiceSet.new dice: { count: 2 } }

      describe 'should generate missing values' do
        it { expect(subject.roll).to eq dice: [6, 6] }
        it { expect(subject.roll({})).to eq dice: [6, 6] }
        it { expect(subject.roll(dice: [])).to eq dice: [6, 6] }
        it { expect(subject.roll(dice: [1])).to eq dice: [1, 6] }
      end

      describe 'should ignore extra values' do
        it { expect(subject.roll(dice: [1, 2, 3])).to eq dice: [1, 2] }
        it { expect(subject.roll(dice: [1, 2], extra: [1])).to eq dice: [1, 2] }
      end
    end

    context 'set of two' do
      subject { DiceSet.new first: { count: 2 }, second: { count: 2 } }

      describe 'should generate missing values' do
        it { expect(subject.roll). to eq first: [6, 6], second: [6, 6] }
        it { expect(subject.roll({})). to eq first: [6, 6], second: [6, 6] }
        it { expect(subject.roll(first: [], second: [])). to eq first: [6, 6], second: [6, 6] }
        it { expect(subject.roll(first: [1], second: [1])). to eq first: [1, 6], second: [1, 6] }
      end

      describe 'should ignore extra values' do
        it { expect(subject.roll(first: [1, 2, 3], second: [1, 2, 3])).to eq first: [1, 2], second: [1, 2] }
        it { expect(subject.roll(first: [1, 2, 3], extra: [1, 2, 3])).to eq first: [1, 2], second: [6, 6] }
      end
    end
  end
end
