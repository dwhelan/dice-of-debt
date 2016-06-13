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
      expect(status).to eq status_code
      expect_response(:data)
    end

    def expect_error(status_code)
      expect(status).to eq status_code
      expect_response(:errors)
    end

    def expect_response(*types)
      expect(headers['Content-Type']).to eq 'application/vnd.api+json'
      expect(json).to eq types if json.keys != types # Output full json to help diagnose failure
    end

    let(:headers) { last_response.headers }
    let(:status)  { last_response.status  }
    let(:body)    { last_response.body    }
    let(:data)    { json[:data] }
    let(:errors)  { json[:errors] }
    let(:error)   { errors.first }

    let(:json)    do
      begin
        symbolize_keys(JSON.parse(body))
      rescue
        puts body
        raise
      end
    end

    subject { last_response }
  end
end
