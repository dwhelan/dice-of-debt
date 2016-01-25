require 'grape'

module DiceOfDebt
  # The API application class
  class API < Grape::API
    resource :game do
      helpers do
        def repository
          Persistence.game_repository
        end
      end

      get do
        repository.all.map(&:attributes).to_json
      end

      post do
        header 'Location', '/game/1'
        Game.new(id: 1).attributes.to_json
      end
    end
  end
end
