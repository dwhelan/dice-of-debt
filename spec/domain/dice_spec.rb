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
        expect(subject.value).to eq expected
      end

      specify 'roll with values' do
        expect(subject.roll(5, 6)).to eq [5, 6]
      end

      specify 'roll with missing values' do
        expect(subject.roll(5)[0]).to eq 5
        expect(subject.roll(5)[1]).to be > 0
        expect(subject.roll(5)[1]).to be < 7
      end
    end
  end
end
