module DiceOfDebt
  class API
    resource :errors do
      desc 'Raise an error.'
      post do
        fail 'Internal Server Error'
      end

      get do
        fail 'Internal Server Error'
      end
    end

    helpers do
      def error(options = {})
        error = Error.new(options)

        status error.status
        present [error], with: ErrorArrayPresenter
        nil
      end
    end

    rescue_from :all do |e|
      error = API::Error.new(status: 500, title: e.message, backtrace: e.backtrace)
      ErrorResponse.build error.status, [error]
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      errors = e.map do |attributes, error|
        message = e.send(:full_message, attributes, error)
        Error.new(status: 422, title: message, source: { parameter: attributes.join(',') })
      end

      ErrorResponse.build 422, errors
    end

    class Error
      attr_reader :status, :title, :detail, :source, :backtrace

      def initialize(opts = {})
        @status = opts[:status] || 500
        @title  = opts[:title] || Rack::Utils::HTTP_STATUS_CODES[status]
        @detail = opts[:detail] || title
        @source = opts[:source]
        @backtrace = opts[:backtrace]
      end
    end

    module ErrorPresenter
      include Representer

      property :status, getter: -> _ { status.to_s }
      property :title
      property :detail
      property :source
      property :backtrace if ENV['RACK_ENV'] != 'production'
    end

    module ErrorArrayPresenter
      include Representer

      collection :entries, as: 'errors', extend: ErrorPresenter, embedded: true
    end

    module ErrorResponse
      def self.build(status, errors)
        headers = { 'Content-Type' => JSON_API_CONTENT_TYPE }
        [status, headers, [ErrorArrayPresenter.represent(errors).to_json]]
      end
    end
  end
end
