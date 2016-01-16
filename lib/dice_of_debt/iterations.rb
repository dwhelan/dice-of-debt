require 'forwardable'

module DiceOfDebt
  # The Iterations class is responsible for maintaining a doubly linked list of Iterations.
  class Iterations
    attr_accessor :current, :iterations

    extend Forwardable
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
  end
end
