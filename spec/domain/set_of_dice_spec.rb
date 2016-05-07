require 'spec_helper'

module DiceOfDebt
  describe SetOfDice do
    describe 'no dice' do
      subject { SetOfDice.new }

      its(:roll) { should eq({}) }
    end

    def ensure_that_random_roll_is_always_a_six
      allow(Random).to receive(:rand) { 5 }
    end

    before do
      ensure_that_random_roll_is_always_a_six
    end

    xdescribe 'one group of dice' do
      subject { SetOfDice.new dice: Dice.new(1, 1) }

      it { expect(subject.roll). to eq dice: [1] }
      it { expect(subject.roll(dice: [1])). to eq dice: [1] }
      it { expect(subject.roll(dice: [])). to eq dice: [1] }
    end

    xdescribe 'two groups of dice' do
      subject { SetOfDice.new dice1: Dice.new(1, 1), dice2: Dice.new(1, 1) }

      it { expect(subject.roll). to eq dice1: [1], dice2: [1] }
      it { expect(subject.roll(dice1: [])). to eq dice1: [1], dice2: [1] }
      it { expect(subject.roll(dice1: [])). to eq dice1: [1], dice2: [1] }
    end

    let (:empty_set)  { SetOfDice.new }
    let (:set_of_one) { SetOfDice.new(first: Dice.new(2)) }

    describe 'should use provided values' do
      it { expect(set_of_one.roll(first: [1, 2])).to eq first: [1, 2] }
    end

    describe 'should generate missing values' do
      it { expect(set_of_one.roll(first: [])).to eq  first: [6, 6] }
      it { expect(set_of_one.roll(first: [1])).to eq first: [1, 6] }
    end

    describe 'should ignore extra values' do
      it { expect(set_of_one.roll(first: [1, 2, 3])).to eq first: [1, 2] }
    end
    # describe '6 sided dice' do
    #   subject { Dice.new 2 }
    #
    #   specify "it's value should be the same as the last roll" do
    #     expected = subject.roll
    #     expect(subject.values).to eq expected
    #   end
    #
    #   specify 'roll with values should use value' do
    #     expect(subject.roll(5, 6)).to eq [5, 6]
    #   end
    #
    #   specify 'roll random values with missing values' do
    #     expect(subject.roll(5)[0]).to eq 5
    #     expect(subject.roll(5)[1]).to be > 0
    #     expect(subject.roll(5)[1]).to be < 7
    #   end
    #
    #   specify 'ignore roll with extra values' do
    #     expect(subject.roll(5, 6, 7)).to eq [5, 6]
    #   end
    #
    #   specify 'roll with array of values' do
    #     expect(subject.roll([5, [6]])).to eq [5, 6]
    #   end
    #
    #   specify 'should provide a total' do
    #     subject.roll(5, 6)
    #     expect(subject.total).to eq 11
    #   end
    # end
  end
end
