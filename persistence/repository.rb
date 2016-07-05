module DiceOfDebt
  module Persistence
    class Repository < ::ROM::Repository
      def save(object)
        object.id ? update(object) : create(object) if object
      end
    end
  end
end
