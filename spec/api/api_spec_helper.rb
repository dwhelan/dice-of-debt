require 'spec_helper'
require 'rack/test'

require_relative '../../api'

module DiceOfDebt
  shared_context 'api test' do
    include Rack::Test::Methods

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
      if json.keys != types
        expect(json).to eq types # Output full json to help diagnose failure
      else
        expect(headers['Content-Type']).to eq 'application/vnd.api+json'
      end
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

  shared_context 'populate database' do
    before :all do
      connection = Persistence.connection

      connection.create_table :games do
        primary_key :id
      end

      connection[:games].insert id: '1'
    end
  end
end
