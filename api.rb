require 'grape'
require 'grape-entity'

module DiceOfDebt
  # The API application class
  class API < Grape::API
    # The API entity for rendering errors
    class Error < Grape::Entity
      expose :message
    end

    # Return validation errors
    class ValidationError < Grape::Entity
      expose :errors
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({ errors: e.full_messages, with: API::ValidationError }, 400)
    end

    resource :game do
      helpers do
        def repository
          Persistence.game_repository
        end
      end

      desc 'Get all games.'
      get do
        repository.all.map(&:attributes).to_json
      end

      desc 'Get a game.' do
        failure [[400, 'id is invalid', API::Error]]
      end
      params do
        requires :id, type: Integer, desc: 'Game id.'
      end

      route_param :id do
        get do
          game = repository.with_id(params[:id])
          game ? game.attributes.to_json : error!({ message: 'Not Found', with: API::Error }, 404)
        end
      end

      desc 'Create a game.'
      post do
        header 'Location', '/game/1'
        Game.new(id: 1).attributes.to_json
      end
    end

    route :any, '*path' do
      error!({ message: 'Invalid URI', with: API::Error }, 404)
    end
  end
end
