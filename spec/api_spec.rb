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

      context 'when game is not found' do
        before { get '/game/9999' }

        it { expect(status).to eq 404 }
        it { expect(body).to include '"message":"Not Found"' }
      end
    end

    describe 'POST /game' do
      specify 'with a valid game' do
        post '/game'

        expect(status).to eq 201
        expect(body).to include '"id":1'
        expect(headers['Location']).to eq '/game/1'
      end
    end
  end
end
