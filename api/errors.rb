require 'pad'

module DiceOfDebt

  class API

    class Error
      include ::Pad.model

      attribute :status, Integer, default: 500
      attribute :title,  String,  default: lambda { |error, _| Rack::Utils::HTTP_STATUS_CODES[error.status.to_i] }
    end

    class ForcedError < StandardError
    end

    module ErrorPresenter
      include Presenter

      property :title
    end

    module ErrorArrayPresenter
      include Presenter

      collection :entries, as: 'errors', extend: ErrorPresenter, embedded: true

      def self.call(message, backtrace, options, env)
        error = API::Error.new(status: 500, title: message)
        ErrorArrayPresenter.represent([error]).to_json
      end
    end

    helpers do
      def error(options={})
        error = Error.new(options)

        status error.status
        present [error], with: ErrorArrayPresenter
      end
    end

    error_formatter :json, ErrorArrayPresenter

    rescue_from :all
    rescue_from Grape::Exceptions::ValidationErrors do |e|
      headers = { 'Content-Type' => JSON_API_CONTENT_TYPE }
      errors = e.full_messages.map do |message|
        Error.new(status: e.status, title: message)
      end

      [e.status, headers, ErrorArrayPresenter.represent(errors).to_json]
    end

    resource :errors do
      desc 'Raise an error.'
      post do
        raise ForcedError, 'Internal Server Error'
      end
    end
  end
end
