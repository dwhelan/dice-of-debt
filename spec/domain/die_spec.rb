require 'spec_helper'

module DiceOfDebt
  describe Die do
    it { expect { Die.new 0 } .to raise_error ArgumentError }

    it { expect(Die.new(12).sides).to eq 12 }

    describe 'a 6 sided die' do
      its(:sides) { should eq 6 }
      its(:value) { should eq 0 }

      its(:roll) { should > 0 }
      its(:roll) { should < 7 }

      specify "it's value should be the same as the last roll" do
        expected = subject.roll
        expect(subject.value).to eq expected
      end

      specify 'roll with value' do
        expect(subject.roll(6)).to eq 6
      end

      it { expect { subject.roll(0) }.to raise_error ArgumentError }
      it { expect { subject.roll(7) }.to raise_error ArgumentError }
    end

    describe 'a one-sided die' do
      subject { Die.new 1 }

      specify 'roll with no value' do
        expect(subject.roll).to eq 1
        expect(subject.value).to eq 1
      end
    end
  end
end
