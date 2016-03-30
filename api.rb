require 'grape'
require 'grape-entity'
require 'grape-roar'
require 'roar/coercion'
require 'roar/json'

module DiceOfDebt

  module ResourcePresenter
    def self.included(base)
      base.include Roar::JSON
      base.include Grape::Roar::Representer

      base.property :id

      def base.type type
        property :type, getter: ->(_) { type }
      end

      def base.resource_presenter presenter
        self.representation_wrap = :data
        include presenter
      end
    end
  end

  module ResourceArrayPresenter
    def self.included(base)
      base.include Roar::JSON
      base.include Grape::Roar::Representer

      def base.resource_presenter presenter
        collection :entries, as: 'data', extend: presenter, embedded: true
      end
    end
  end

  module GamePresenter
    include ResourcePresenter

    type 'game'
  end

  module GameDocumentPresenter
    include ResourcePresenter

    resource_presenter GamePresenter
  end

  module GameArrayDocumentPresenter
    include ResourceArrayPresenter

    resource_presenter GamePresenter
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
        present repository.all, with: GameArrayDocumentPresenter
      end

      desc 'Get a game.' do
        failure [[400, 'id is invalid', API::Error]]
      end
      params do
        requires :id, type: Integer, desc: 'Game id.'
      end

      route_param :id do
        get do
          if game = repository.with_id(params[:id])
            present game, with: GameDocumentPresenter
          else
            error!({message: 'Not Found', with: API::Error }, 404)
          end
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