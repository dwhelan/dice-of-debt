module DiceOfDebt

  class API
    class Error
      include Pad.model

      attribute :status, Integer, default: 500
      attribute :title,  String,  default: lambda { |error, _| Rack::Utils::HTTP_STATUS_CODES[error.status.to_i] }
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

    helpers do
      def error(options={})
        error = Error.new (options)

        status error.status
        present [error], with: ErrorArrayPresenter
      end
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      headers = { Grape::Http::Headers::CONTENT_TYPE => 'application/vnd.api+json' }
      errors = e.full_messages.map do |message|
        Error.new ({status: e.status, title: message})
      end

      [e.status, headers, ErrorArrayPresenter.represent(errors).to_json]
    end
  end
end
