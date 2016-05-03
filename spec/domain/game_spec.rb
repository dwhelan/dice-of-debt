require 'spec_helper'

module DiceOfDebt
  describe Game do
    let(:game)    { Game.new }
    let(:subject) { game }
    let(:config)  { game.config }
    let(:roller)  { double('roller', roll: 1) }

    before do
      config.value_dice.roller = config.debt_dice.roller = roller
      config.value_dice.count  = 8
      config.debt_dice.count   = 4
    end

    describe 'initially' do
      its(:score)      { should be 0 }
      its(:iterations) { should have(0).iterations }
    end

    describe 'first iteration' do
      # before { game.start_iteration }

      describe 'rolling value dice' do
        before { game.roll_value_dice }

        its(:score)             { should be 8 }
        its(:'iteration.value') { should be 8 }
        its(:'iteration.score') { should be 8 }
      end

      describe 'rolling debt dice' do
        before { game.roll_debt_dice }

        its(:score)             { should be(-4) }
        its(:'iteration.score') { should be(-4) }
        its(:'iteration.debt')  { should be 4 }
      end

      describe 'after one iteration' do
        before { play_one_iteration }

        its(:score) { should be 4 }
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
        game.roll_value_dice
        game.roll_debt_dice
        game.end_iteration
      end
    end
  end

  describe 'configuration' do
    subject { Game.new.config }

    its(:iterations) { should be 10 }

    describe 'value_dice' do
      subject { Game.new.config.value_dice }

      its(:count)  { should be 8 }
      its(:sides)  { should be 6 }
      its(:roller) { should be_a RandomRoller }

      its(:'roller.sides') { should be 6 }
    end

    describe 'debt_dice' do
      subject { Game.new.config.debt_dice }

      its(:count)  { should be 4 }
      its(:sides)  { should be 6 }
      its(:roller) { should be_a RandomRoller }

      its(:'roller.sides') { should be 6 }
    end
  end
end
