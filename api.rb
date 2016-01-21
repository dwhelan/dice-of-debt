require 'grape'

module DiceOfDebt
  # The API application class
  class API < Grape::API
    resource :game do
      get do
        []
      end

      post do
        header 'Location', '/game/1'
        Game.new(id: 1).attributes.to_json
      end
    end
  end
end
