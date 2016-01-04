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
      @value_dice ||= Dice.new(configuration.value_dice_count, configuration)
    end

    def technical_debt_dice
      @technical_debt_dice ||= Dice.new(configuration.technical_debt_dice_count, configuration)
    end

    def iterations
      @iterations || 10.times.map { Iteration.new }
    end

    class Dice
      attr_accessor :dice

      def initialize(count, options={})
        self.dice = count.times.map { Die.new(options) }
      end

      def roll
        dice.reduce(0) { |sum, die| sum += die.roll }
      end
    end

    class Die
      attr_accessor :prng, :sides

      def initialize(options={})
        self.sides = options[:sides] || 6
        self.prng  = options[:prng]  || Random.new
      end

      def roll
        prng.rand(sides) + 1
      end
    end

    def configuration
      @configuration ||= OpenStruct.new(value_dice_count: 8, technical_debt_dice_count: 4)
    end

    class Iteration

    end
  end
end

module DiceOfDebt
  describe Game do
    before { subject.config.prng = double('rand', rand: 0) } # Always returns 0 => roll of 1

    describe 'initially' do
      its(:score)              { should be 0  }
      its(:"iterations.count") { should be 10  }
    end


    it 'each roll of a value die should increase the score' do
      subject.config do |config|
        config.value_dice_count = 1
        config.technical_debt_dice_count = 0
      end
      subject.roll
      expect(subject.score).to eq 1
    end

    it 'each roll of a technical debt die should decrease the score' do
      subject.config do |config|
        config.value_dice_count = 0
        config.technical_debt_dice_count = 1
      end
      subject.roll
      expect(subject.score).to eq -1
    end
  end

  describe 'Configuration' do
    subject { Game.new.config }

    its(:value_dice_count)          { should be 8 }
    its(:technical_debt_dice_count) { should be 4 }
  end
end
