require 'forwardable'

module DiceOfDebt
  # The Iterations class is responsible for maintaining a doubly linked list of Iterations.
  class Iterations
    include Enumerable
    extend Forwardable

    attr_accessor :current

    def_delegators :iterations, :count, :[]

    def initialize(count)
      self.iterations = [self.current = Iteration.new]

      (count - 1).times do
        previous = iterations.last
        iterations << Iteration.new(previous)
        previous.next = iterations.last
      end
    end

    def next
      self.current = current.next
    end

    def each(&block)
      iterations.each { |iteration| block.call(iteration) }
    end

    private

    attr_accessor :iterations
  end

  class Team
    include Enumerable

    attr_accessor :members

    def initialize
      @members = []
    end

    def each &block
      @members.each{|member| block.call(member)}
    end
  end
end
