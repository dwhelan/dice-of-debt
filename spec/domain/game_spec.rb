require 'spec_helper'

module DiceOfDebt
  describe Game do
    let(:game)    { Game.new }
    let(:subject) { game }
    let(:config)  { game.config }
    let(:roller)  { double('roller', roll: 1) }

    before do
      config[:dice][:value][:count]  = 8
      config[:dice][:value][:sides]  = 1
      config[:dice][:debt][:count]   = 4
      config[:dice][:debt][:sides]   = 1
    end

    describe 'initially' do
      its(:score)      { should be 0 }
      its(:iterations) { should have(0).iterations }
    end

    describe 'first iteration' do
      describe 'rolling' do
        before { game.roll }

        its(:'iteration.value') { should be 8 }
        its(:'iteration.debt')  { should be 4 }
        its(:'iteration.score') { should be 4 }
        its(:score)             { should be 4 }
      end

      describe 'after 10 iterations' do
        before { 10.times { play_one_iteration } }

        its(:iteration) { should be game.iterations[9] }
        its(:score)     { should be 40 }
      end

      describe 'after 11 iterations' do
        before { 11.times { play_one_iteration } }

        its(:iteration) { should be game.iterations[9] }
        its(:score)     { should be 40 }
      end

      def play_one_iteration
        game.roll
        game.end_iteration
      end
    end
  end

  describe 'configuration' do
    subject { Game.new.config }

    its([:iterations]) { should be 10 }

    describe 'value_dice' do
      subject { Game.new.config[:dice][:value] }

      its([:count]) { should be 8 }
      its([:sides]) { should be 6 }
    end

    describe 'debt_dice' do
      subject { Game.new.config[:dice][:debt] }

      its([:count])  { should be 4 }
      its([:sides])  { should be 6 }
    end
  end
end
