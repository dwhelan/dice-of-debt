require 'spec_helper'

module DiceOfDebt
  describe DiceSet do
    before { allow(RandomRoller).to receive(:roll) { 6 } }

    context 'empty set' do
      subject { DiceSet.new }

      describe 'should allow empty values' do
        it { expect(subject.roll).to eq({}) }
        it { expect(subject.roll({})).to eq({}) }
        it { expect(subject.roll(dice: [])).to eq({}) }
      end

      describe 'should allow numeric values' do
        it { expect(subject.roll(dice: [1, 2])).to eq({}) }
        it { expect(subject.roll(dice: [1, 2], second: [1])).to eq({}) }
      end

      describe 'should allow string values' do
        it { expect(subject.roll(dice: %w(1))).to eq({}) }
        it { expect(subject.roll(dice: %w(1 2), second: [1])).to eq({}) }
      end
    end

    context 'set of one' do
      subject { DiceSet.new dice: { count: 2 } }

      describe 'should generate missing values' do
        it { expect(subject.roll).to eq dice: %w(6 6) }
        it { expect(subject.roll({})).to eq dice: %w(6 6) }
        it { expect(subject.roll(dice: [])).to eq dice: %w(6 6) }
        it { expect(subject.roll(dice: [1])).to eq dice: %w(1 6) }
      end

      describe 'should ignore extra values' do
        it { expect(subject.roll(dice: [1, 2, 3])).to eq dice: %w(1 2) }
        it { expect(subject.roll(dice: [1, 2], extra: [1])).to eq dice: %w(1 2) }
      end

      describe 'should allow string values' do
        it { expect(subject.roll(dice: %w(1 2 3))).to eq dice: %w(1 2) }
        it { expect(subject.roll(dice: %w(1 2), extra: %w(1))).to eq dice: %w(1 2) }
      end
    end

    context 'set of two' do
      subject { DiceSet.new first: { count: 2 }, second: { count: 2 } }

      describe 'should generate missing values' do
        it { expect(subject.roll). to eq first: %w(6 6), second: %w(6 6) }
        it { expect(subject.roll({})). to eq first: %w(6 6), second: %w(6 6) }
        it { expect(subject.roll(first: [], second: [])). to eq first: %w(6 6), second: %w(6 6) }
        it { expect(subject.roll(first: [1], second: [1])). to eq first: %w(1 6), second: %w(1 6) }
      end

      describe 'should ignore extra values' do
        it { expect(subject.roll(first: [1, 2, 3], second: [1, 2, 3])).to eq first: %w(1 2), second: %w(1 2) }
        it { expect(subject.roll(first: [1, 2, 3], extra:  [1, 2, 3])).to eq first: %w(1 2), second: %w(6 6) }
      end
    end
  end
end
