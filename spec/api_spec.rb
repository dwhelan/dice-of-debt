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

      connection[:games].insert id: 1
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

    specify 'GET /game' do
      get '/game'

      expect(status).to eq 200
      expect(body).to include '"id":1'
    end

    describe 'GET /game/{id}' do
      specify 'when game is found' do
        get '/game/1'

        expect(status).to eq 200
        expect(body).to include '"id":1'
      end

      specify 'when game is not found' do
        get '/game/9999'

        expect(status).to eq 404
        expect(body).to include '"message":"Not Found"'
      end

      specify 'when game id is invalid' do
        get '/game/foo'

        expect(status).to eq 400
        expect(body).to eq({
          errors: ['id is invalid']
        }.to_json)
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
