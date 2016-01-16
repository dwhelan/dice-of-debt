require 'spec_helper'

module DiceOfDebt
  class Game
    attr_accessor :score, :iteration

    def initialize
      self.score     = 0
      self.iteration = iterations.first
    end

    def roll
      self.score += roll_value_dice - roll_technical_debt_dice
    end

    def config
      yield configuration if block_given?
      configuration
    end

    def value_dice
      @value_dice ||= Dice.new(configuration.value_dice)
    end

    def roll_value_dice
      iteration.new_value = value_dice.roll
    end

    def roll_technical_debt_dice
      iteration.technical_debt = technical_debt_dice.roll
    end

    def technical_debt_dice
      @technical_debt_dice ||= Dice.new(configuration.technical_debt_dice)
    end

    def iterations
      @iterations ||= Array.new(config.iterations) { Iteration.new(0) }
    end

    class Dice
      attr_accessor :dice

      def initialize(options)
        self.dice = Array.new(options.count) { Die.new(options) }
      end

      def roll
        dice.reduce(0) { |sum, die| sum + die.roll }
      end
    end

    class Die
      attr_accessor :roller

      def initialize(options)
        self.roller = options.roller
      end

      def roll
        roller.roll
      end
    end

    def configuration
      @configuration ||= begin
        sides               = 6
        value_dice          = OpenStruct.new(count: 8, sides: sides, roller: RandomRoller.new(sides))
        technical_debt_dice = OpenStruct.new(count: 4, sides: sides, roller: RandomRoller.new(sides))

        OpenStruct.new(value_dice: value_dice, technical_debt_dice: technical_debt_dice, iterations: 10)
      end
    end
  end

  class RandomRoller
    attr_accessor :sides

    def initialize(sides)
      self.sides = sides
    end

    def roll
      Random.rand(sides) + 1
    end
  end

  class Iteration
    attr_accessor :initial_value, :new_value, :technical_debt

    def initialize(initial_value)
      self.initial_value  = initial_value
      self.technical_debt = 0
      self.new_value      = 0
    end

    def value
      initial_value + new_value - technical_debt
    end
  end
end

module DiceOfDebt
  describe Game do
    let(:game)    { Game.new }
    let(:subject) { game }
    let(:config)  { game.config }
    let(:roller)  { double('roller', roll: 1) }

    before do
      config.value_dice.roller         = config.technical_debt_dice.roller = roller
      config.value_dice.count          = 8
      config.technical_debt_dice.count = 4
    end

    describe 'initially' do
      its(:score)              { should be 0 }
      its(:"iterations.count") { should be config.iterations }
    end

    specify 'each roll of a value die should increase the score' do
      config.technical_debt_dice.count = 0
      game.roll
      expect(game.score).to eq 8
    end

    specify 'each roll of a technical debt die should decrease the score' do
      config.value_dice.count = 0
      game.roll
      expect(game.score).to eq (-4)
    end

    describe 'iteration' do
      subject { game.iterations.first }

      describe 'rolling value dice' do
        before { game.roll_value_dice }
        its(:new_value) { should be 8 }
        its(:value)     { should be 8 }
      end

      describe 'rolling debt dice' do
        before { game.roll_technical_debt_dice }
        its(:technical_debt) { should be 4 }
        its(:value)          { should be -4 }
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

      its(:"roller.sides") { should be 6 }
    end

    describe 'technical_debt_dice' do
      subject { Game.new.config.technical_debt_dice }

      its(:count)  { should be 4 }
      its(:sides)  { should be 6 }
      its(:roller) { should be_a RandomRoller }

      its(:"roller.sides") { should be 6 }
    end
  end
end
