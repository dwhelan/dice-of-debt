module DiceOfDebt
  module AutoRegister
    def self.included(base)
      case
      when base < ROM::Relation
        Persistence.configuration.register_relation(base)
      when base < ROM::Command
        Persistence.configuration.register_command(base)
      end
    end
  end
end
