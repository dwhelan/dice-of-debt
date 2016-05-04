require 'spec_helper'

module DiceOfDebt
  describe Dice do
    describe 'one-sided dice' do
      subject { Dice.new 2, 1 }

      its(:roll) { should eq [1, 1] }
    end

    describe '6 sided dice' do
      subject { Dice.new 2 }

      specify "it's value should be the same as the last roll" do
        expected = subject.roll
        expect(subject.values).to eq expected
      end

      specify 'roll with values should use value' do
        expect(subject.roll(5, 6)).to eq [5, 6]
      end

      specify 'roll random values with missing values' do
        expect(subject.roll(5)[0]).to eq 5
        expect(subject.roll(5)[1]).to be > 0
        expect(subject.roll(5)[1]).to be < 7
      end

      specify 'ignore roll with extra values' do
        expect(subject.roll(5, 6, 7)).to eq [5, 6]
      end

      specify 'roll with array of values' do
        expect(subject.roll([5, [6]])).to eq [5, 6]
      end

      specify 'should provide a total' do
        subject.roll(5, 6)
        expect(subject.total).to eq 11
      end
    end
  end
end
