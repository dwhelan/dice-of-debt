require 'grape'
require 'grape-entity'

module DiceOfDebt
  # The API application class
  class API < Grape::API
    class Error < Grape::Entity
      expose :message
    end

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
          game ? game.attributes.to_json : error!({ message: 'Not Found', with: API::Error }, 404)
        end
      end

      post do
        header 'Location', '/game/1'
        Game.new(id: 1).attributes.to_json
      end
    end

    route :any, '*path' do
      error!({ message: 'Invalid URI', with: API::Error }, 404)    end
  end
end
