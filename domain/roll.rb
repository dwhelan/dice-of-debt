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
    attribute :game
  end
end
