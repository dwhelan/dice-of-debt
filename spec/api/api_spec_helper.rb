require 'persistent_spec_helper'
require 'rack/test'

require_relative '../../api'

module DiceOfDebt
  shared_context 'api test' do
    include Rack::Test::Methods

    before do
      insert_data :games, id: 1, score: 0
    end

    after do
      delete_all_data :rolls
      delete_data :iterations, game_id: 1
      delete_data :games, id: 1
    end

    def symbolize_keys(object)
      case object
      when Hash
        object.each_with_object({}) { |(key, value), memo| memo[key.to_sym] = symbolize_keys(value) }
      when Array
        object.each_with_object([]) { |value, memo| memo << symbolize_keys(value) }
      else
        object
      end
    end

    def app
      API
    end

    def expect_data(status_code)
      expect_response(:data)
      pp json if status != status_code && status_code != 500
      expect(status).to eq status_code
    end

    def expect_error(status_code)
      expect(status).to eq status_code
      expect_response(:errors)
    end

    def expect_response(*types)
      expect(headers['Content-Type']).to eq 'application/vnd.api+json'
      expect(json).to eq types if json.keys != types # Output full json to help diagnose failure
    end

    let(:data)    { json[:data] }
    let(:errors)  { json[:errors] }
    let(:error)   { errors.first }

    # Don't use let() in case the spec invokes multiple requests
    # in which case we don't want the last response memoized.
    def headers
      last_response.headers
    end

    def status
      last_response.status
    end

    def body
      last_response.body
    end

    def json
      symbolize_keys(JSON.parse(last_response.body))
    rescue
      puts body
      raise
    end

    subject { last_response }
  end
end
