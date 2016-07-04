require 'pad'

module DiceOfDebt
  class Json < Virtus::Attribute
    def coerce(value)
      value.is_a?(::Hash) ? value : JSON.parse(value).symbolize_keys
    end
  end

  class Roll
    include Pad.entity

    attribute :rolls, Json, default: {}
    attribute :iteration

    # def initialize(id, rolls)
    #   self.id    = id || 1
    #   self.rolls = rolls
    # end

    # private
    #
    # attr_writer :id, :rolls
  end
end
