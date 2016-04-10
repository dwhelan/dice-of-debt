require 'pad'

module DiceOfDebt

  class API

    class Error
      attr_reader :status, :title, :detail

      def initialize(opts={})
        @status = opts[:status] || 500
        @title  = opts[:title]  || Rack::Utils::HTTP_STATUS_CODES[status]
        @detail = opts[:detail] || title
      end
    end

    module ErrorPresenter
      include Presenter

      property :status, getter: ->(_) { status.to_s }
      property :title
      property :detail
    end

    module ErrorArrayPresenter
      include Presenter

      collection :entries, as: 'errors', extend: ErrorPresenter, embedded: true
    end

    module ErrorResponse
      def self.build(status, errors)
        headers = { 'Content-Type' => JSON_API_CONTENT_TYPE }
        [status, headers, ErrorArrayPresenter.represent(errors).to_json]
      end
    end

    helpers do
      def error(options={})
        error = Error.new(options)

        status error.status
        present [error], with: ErrorArrayPresenter
      end
    end

    rescue_from :all do |e|
      error = API::Error.new(status: 500, title: e.message)
      ErrorResponse.build error.status, [error]
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
     errors = e.full_messages.map do |message|
       Error.new(status: e.status, title: message)
     end
     ErrorResponse.build e.status, errors
    end

    resource :errors do
      desc 'Raise an error.'
      post do
        raise 'Internal Server Error'
      end
    end
  end
end
