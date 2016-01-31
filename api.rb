require 'grape'
require 'grape-entity'
require 'grape-roar'
require 'roar/json'

module DiceOfDebt
  module Presenter
    def self.included(base)
      base.instance_eval do
        include Roar::JSON
        include Roar::Hypermedia
        include Grape::Roar::Representer
      end
    end
  end

  module GamePresenter
    include Presenter

    property :id
  end

  module GamesPresenter
    include Presenter

    collection :to_a, extend: GamePresenter, as: :games, embedded: true
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

    resource :game do
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
          game ? present(game, with: GamePresenter) : error!({message: 'Not Found', with: API::Error }, 404)
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
