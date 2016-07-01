module DiceOfDebt
  class API
    module IterationRepresenter
      include ResourceRepresenter

      property :value
      property :debt
      property :score
    end
  end
end
