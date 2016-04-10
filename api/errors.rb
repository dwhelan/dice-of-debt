require 'pad'

module DiceOfDebt

  class API

    class Error
      attr_reader :status, :title

      def initialize(opts={})
        self.status = opts[:status] || 500
        self.title  = opts[:title]  || Rack::Utils::HTTP_STATUS_CODES[status]
      end

      private

      attr_writer :status, :title
    end

    module ErrorPresenter
      include Presenter

      property :title
    end

    module ErrorArrayPresenter
      include Presenter

      collection :entries, as: 'errors', extend: ErrorPresenter, embedded: true
    end

    helpers do
      def error(options={})
        error = Error.new(options)

        status error.status
        present [error], with: ErrorArrayPresenter
      end
    end

    rescue_from :all do |e|
      status, errors = case e
               when Grape::Exceptions::ValidationErrors
                 errors = e.full_messages.map do |message|
                   Error.new(status: e.status, title: message)
                 end
                 [e.status, errors]
               else
                 [500, [API::Error.new(status: 500, title: e.message)]]
               end
      headers = { 'Content-Type' => JSON_API_CONTENT_TYPE }
      [status, headers, ErrorArrayPresenter.represent(errors).to_json]
    end

    resource :errors do
      desc 'Raise an error.'
      post do
        raise 'Internal Server Error'
      end
    end
  end
end
