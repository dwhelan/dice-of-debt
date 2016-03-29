require 'grape'
require 'grape-entity'
require 'grape-roar'
require 'roar/coercion'
require 'roar/json'

module DiceOfDebt
  # module Presenter
  #   def self.included(base)
  #     base.instance_eval do
  #       include Roar::JSON::JSONAPI
  #       include Grape::Roar::Representer
  #     end
  #   end
  # end

  class GamePresenter < Grape::Roar::Decorator
    include Roar::JSON

    property :type, getter: ->(represented) { 'game' }
    property :id
  end

  class GameDocumentPresenter < GamePresenter
    include Roar::JSON

    self.representation_wrap = :data
  end

  class GamesPresenter < Grape::Roar::Decorator
    include Roar::JSON

    collection :entries, as: 'data', extend: GamePresenter, embedded: true
  end

  # The API application class
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar

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

    resource :games do
      helpers do
        def repository
          Persistence.game_repository
        end
      end

      desc 'Get all games.'
      get do
        present repository.all, with: GamesPresenter
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
          game ? GameDocumentPresenter.new(game) : error!({message: 'Not Found', with: API::Error }, 404)
        end
      end

      desc 'Create a game.'
      post do
        header 'Location', '/game/1'
        Game.new(id: '1').attributes.to_json
      end
    end

    route :any, '*path' do
      error!({ message: 'Invalid URI', with: API::Error }, 404)
    end
  end
end
