require 'spec_helper'
require 'rack/test'
require_relative '../api'

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

    subject { last_response }

    let(:headers) { last_response.headers }
    let(:status)  { last_response.status  }
    let(:body)    { last_response.body    }
    let(:game1)   { { games: { id: '1' } }    }

    specify 'get all games' do
      get '/games'

      expect(status).to eq 200
      data = JSON.parse(body)['data']
      expect(data.length).to eq 1
      expect(data[0]['type']).to eq 'game'
      expect(data[0]['id']).to eq '1'
    end

    describe 'get game' do
      specify 'when game is found' do
        get '/games/1'

        expect(status).to eq 200
        data = JSON.parse(body)['data']
        expect(data['type']).to eq 'game'
        expect(data['id']).to eq '1'
      end

      specify 'when game is not found' do
        get '/games/9999'

        expect(status).to eq 404
        expect(body).to include '"message":"Not Found"'
      end

      specify 'when game id is invalid' do
        get '/games/foo'

        expect(status).to eq 400
        expect(body).to eq({
          errors: ['id is invalid']
        }.to_json)
      end
    end

    describe 'create game' do
      specify 'with a valid game' do
        data = { data: { } }
        post '/games', data.to_json, {'CONTENT_TYPE' => 'application/json'}

        expect(status).to eq 201
        data = JSON.parse(body)['data']
        expect(data['type']).to eq 'game'
        expect(data['id']).to eq '2'
      end
    end

    describe 'GET /foo' do
      specify 'with an invalid URI' do
        get '/foo'

        expect(status).to eq 404
        expect(body).to include '"message":"Invalid URI"'
      end
    end
  end
end
