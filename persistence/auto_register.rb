module DiceOfDebt
  module AutoRegister
    def self.included(base)
      case
      when base < ROM::Relation
        Persistence::ROM.configuration.register_relation(base)
      when base < ROM::Command
        Persistence::ROM.configuration.register_command(base)
      end
    end
  end
end
