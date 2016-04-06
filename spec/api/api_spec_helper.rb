require 'spec_helper'
require 'rack/test'

require_relative '../../api'

module DiceOfDebt
  shared_context 'api test' do
    include Rack::Test::Methods

    def app
      API
    end

    def expect_data(status_code)
      expect_response(status_code, ['data'])
    end

    def expect_error(status_code)
      expect_response(status_code, ['errors'])
    end

    def expect_response(status_code, types)
      expect(status).to eq status_code
      expect(headers['Content-Type']).to eq 'application/vnd.api+json'
      expect(json.keys).to eq types
    end

    let(:headers) { last_response.headers }
    let(:status)  { last_response.status  }
    let(:body)    { last_response.body    }
    let(:json)    { JSON.parse(body) }
    let(:data)    { json['data'] }
    let(:errors)  { json['errors'] }
    let(:error)   { errors.first }

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
