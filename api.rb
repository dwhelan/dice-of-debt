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

      desc 'Return a game.'
      params do
        requires :id, type: Integer, desc: 'Game id.'
      end

      route_param :id do
        get do
          game = repository.with_id(params[:id])
          game.attributes.to_json
        end
      end

      post do
        header 'Location', '/game/1'
        Game.new(id: 1).attributes.to_json
      end
    end
  end
end
