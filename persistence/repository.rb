module DiceOfDebt
  class Repository < ROM::Repository
    def initialize(rom_container, options = {})
      super
      @rom_container = rom_container
    end

    def command(operation, relation)
      @rom_container.commands[relation][operation]
    end

    def save(object)
      object.id ? update(object) : create(object) if object
    end
  end
end
