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

  describe API do
    include Rack::Test::Methods
    include_context 'populate database'

    def app
      API
    end

    subject { last_response }
    let(:headers) { last_response.headers }

    describe 'GET /game' do

      before do
        get '/game'
      end

      its(:status) { should eq 200 }
      its(:body) { should include '"id":1' }
    end

    describe 'GET /game/1' do

      before do
        get '/game/1'
      end

      its(:status) { should eq 200 }
      its(:body) { should include '"id":1' }
    end

    describe 'POST /game' do
      before do
        post '/game'
      end

      its(:status) { should eq 201 }
      it { expect(headers['Location']).to eq '/game/1' }
      its(:body) { should include '"id":1' }
    end
  end
end
