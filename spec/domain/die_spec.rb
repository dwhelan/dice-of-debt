require 'spec_helper'

module DiceOfDebt
  describe Die do

    subject { Die.new double('roller', roll: 1) }

    specify 'roll with no value' do
      expect(subject.roll).to eq 1
      expect(subject.value).to eq 1
    end

    specify 'roll with value' do
      expect(subject.roll(6)).to eq 6
      expect(subject.value).to eq 6
    end
  end
end
