require 'spec_helper'

module DiceOfDebt
  class Game
    attr_accessor :score

    def initialize
      self.score = 0
    end

    def roll
      self.score += value_dice.roll - technical_debt_dice.roll
    end

    def config
      yield configuration if block_given?
      configuration
    end

    def value_dice
      @value_dice ||= Dice.new(configuration.value_dice)
    end

    def technical_debt_dice
      @technical_debt_dice ||= Dice.new(configuration.technical_debt_dice)
    end

    def iterations
      @iterations || 10.times.map { Iteration.new }
    end

    class Dice
      attr_accessor :dice

      def initialize(options)
        self.dice = options.count.times.map { Die.new(options) }
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
        value_dice          = OpenStruct.new(count: 8, sides: 6, roller: RandomRoller.new(6))
        technical_debt_dice = OpenStruct.new(count: 4, sides: 6, roller: RandomRoller.new(6))
        OpenStruct.new(value_dice: value_dice, technical_debt_dice: technical_debt_dice)
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
  end
end

module DiceOfDebt
  describe Game do
    let(:config) { subject.config }
    let(:roller) { double('roller', roll: 1) }

    before { config.value_dice.roller = config.technical_debt_dice.roller = roller }

    describe 'initially' do
      its(:score)              { should be 0 }
      its(:"iterations.count") { should be 10 }
    end

    it 'each roll of a value die should increase the score' do
      config.value_dice.count = 1
      config.technical_debt_dice.count = 0
      subject.roll
      expect(subject.score).to eq 1
    end

    it 'each roll of a technical debt die should decrease the score' do
      config.value_dice.count = 0
      config.technical_debt_dice.count = 1
      subject.roll
      expect(subject.score).to eq (-1)
    end
  end

  describe 'Configuration' do
    describe 'value_dice' do
      subject { Game.new.config.value_dice }

      its(:count) { should be 8 }
      its(:sides) { should be 6 }
      its(:roller) { should be_a RandomRoller }
      its(:"roller.sides") { should be 6 }
    end

    describe 'technical_debt_dice' do
      subject { Game.new.config.technical_debt_dice }

      its(:count) { should be 4 }
      its(:sides) { should be 6 }
      its(:roller) { should be_a RandomRoller }
      its(:"roller.sides") { should be 6 }
    end
  end
end
