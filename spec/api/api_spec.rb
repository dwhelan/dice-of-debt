require 'spec_helper'
require 'rack/test'

require_relative '../../domain/persistence'
require_relative '../../api/api'

module DiceOfDebt
  shared_context 'populate database' do
    before :all do
      connection = Persistence.connection

      connection.create_table :games do
        primary_key :id
      end

      connection[:games].insert id: '1'
    end
  end

  describe API, :aggregate_failures do
    include Rack::Test::Methods
    include_context 'populate database'

    def app
      API
    end

    def expect_json_api_response(status_code, types)
      expect(status).to eq status_code
      expect(headers['Content-Type']).to eq 'application/vnd.api+json'
      expect(json.keys).to eq types
    end

    def expect_data(status_code)
      expect_json_api_response(status_code, ['data'])
    end

    def expect_error(status_code)
      expect_json_api_response(status_code, ['errors'])
    end

    subject { last_response }

    let(:headers) { last_response.headers }
    let(:status)  { last_response.status  }
    let(:body)    { last_response.body    }
    let(:json)    { JSON.parse(body) }
    let(:data)    { json['data'] }
    let(:errors)  { json['errors'] }
    let(:error)   { errors.first }
    let(:game1)   { { games: { id: '1' } }    }

    specify 'get all games' do
      get '/games'

      expect_data(200)

      expect(data.length).to eq 1
      expect(data[0]['type']).to eq 'game'
      expect(data[0]['id']).to eq '1'
    end

    describe 'get game' do
      specify 'when game is found' do
        get '/games/1'

        expect_data(200)

        expect(data['type']).to eq 'game'
        expect(data['id']).to eq '1'
      end

      specify 'when game is not found' do
        get '/games/9999'

        expect_error(404)

        expect(error['title']).to eq 'Not Found'
      end

      specify 'when game id is invalid' do
        get '/games/foo'

        expect_error(400)

        expect(error['title']).to eq 'id is invalid'
      end
    end

    describe 'Create game' do
      specify 'with a valid game' do
        request_data = { data: { } }
        post '/games', request_data.to_json, {'CONTENT_TYPE' => 'application/vnd.api+json'}

        expect_data(201)
        expect(headers['Location']).to eq '/games/2'

        expect(data['type']).to eq 'game'
        expect(data['id']).to eq '2'
      end
    end

    describe 'GET /foo' do
      specify 'with an invalid URI' do
        get '/foo'

        expect_error(404)
        expect(error['title']).to eq 'Invalid URI'
      end
    end
  end
end
