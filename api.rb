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

  module ErrorPresenter
    include Presenter

    property :title

    # def self.call(message, backtrace, options, env)
    #   API::Error.new ({title: 'ff'}).to_json
    # end
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

    helpers do
      def error(options={})
        error = Error.new (options)

        status error.status
        present [error], with: ErrorArrayPresenter
      end
    end

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

    require_relative 'games'

    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end
  end
end
