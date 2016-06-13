module DiceOfDebt
  module Helpers
    def insert_data(table, values)
      DiceOfDebt::Persistence.connection[table].insert values
    end

    def delete_data(table, values)
      DiceOfDebt::Persistence.connection[table].filter(values).delete
    end
  end
end

