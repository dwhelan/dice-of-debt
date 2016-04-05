require 'grape'
require 'grape-entity'
require 'grape-roar'
require 'roar/coercion'
require 'roar/json'

module DiceOfDebt

  module Presenter
    def self.included(base)
      base.include Roar::JSON
      base.include Grape::Roar::Representer
    end
  end

  module ResourcePresenter
    def self.included(base)
      base.include Presenter

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
      base.include Presenter

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

  module ErrorPresenter
    include Presenter

    property :title

    def self.call(message, backtrace, options, env)
      API::Error.new ({title: 'ff'}).to_json
    end
  end

  module ErrorArrayPresenter
    include Presenter

    collection :entries, as: 'errors', extend: ErrorPresenter, embedded: true
  end

  # The API application class
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar
    # error_formatter :json, ErrorPresenter

    content_type :json, 'application/vnd.api+json'

    class Error
      include Pad.model

      attribute :status, Integer, default: 500
      attribute :title,  String,  default: lambda { |error, _| Rack::Utils::HTTP_STATUS_CODES[error.status.to_i] }
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      headers = { Grape::Http::Headers::CONTENT_TYPE => 'application/vnd.api+json' }
      errors = e.full_messages.map do |message|
        Error.new ({status: e.status, title: message})
      end

      [e.status, headers, ErrorArrayPresenter.represent(errors).to_json]
    end

    helpers do
      def error(options={})
        error = Error.new (options)

        status error.status
        present [error], with: ErrorArrayPresenter
      end
    end

    namespace :games do
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
        failure [[400, 'id is invalid', Error]]
      end
      params do
        requires :id, type: Integer, desc: 'Game id.'
      end

      route_param :id do
        get do
          if game = repository.with_id(params[:id])
            present game, with: GameDocumentPresenter
          else
            error(status: 404)
          end
        end
      end

      desc 'Create a game.'
      post do
        game = GameDocumentPresenter.represent(Game.new).from_json request.body.string
        present repository.create(game), with: GameDocumentPresenter
        header 'Location', "/games/#{game.id}"
      end
    end

    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end
  end
end
