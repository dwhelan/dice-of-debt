require_relative 'api_spec_helper'
require 'rspec/matchers'

module DiceOfDebt
  xdescribe 'Swagger docs' do
    include_context 'api test'

    before { get '/swagger_doc/games' }

    it { expect(status).to eq 200 }
    it { expect(json['apis']).to have(2).items }

    subject { api }

    describe '/games' do
      let(:api) { json['apis'][0] }

      its(['path']) { should eq '/games' }
      its(['operations']) { should have(2).items }

      describe 'GET /games' do
        subject { api['operations'][0] }

        its(['method']) { should eq 'GET' }
        its(['type']) { should eq 'array' }
        its(['parameters']) { should have(0).items }
        its(['summary']) { should eq 'Get all games.' }
        its(['nickname']) { should eq 'getAllGames' }
        its(['notes']) { should eq '' }
      end

      describe 'POST /games' do
        subject { api['operations'][1] }

        its(['method']) { should eq 'POST' }
        its(['type']) { should eq 'void' }
        its(['parameters']) { should have(0).items }
        its(['summary']) { should eq 'Create a game.' }
        its(['nickname']) { should eq 'createAGame' }
        its(['notes']) { should eq '' }
      end
    end

    describe 'GET /games/{id}' do
      let(:api) { json['apis'][1] }
      let(:operation) { api['operations'][0] }

      its(['path']) { should eq '/games/{id}' }
      its(['operations']) { should have(1).item }

      describe 'GET /games/{id}' do
        subject { operation }

        its(['method']) { should eq 'GET' }
        its(['type']) { should eq 'void' }
        its(['summary']) { should eq 'Get a game.' }
        its(['nickname']) { should eq 'getAGame' }
        its(['notes']) { should eq '' }

        its(['parameters']) { should have(1).item }
        its(['responseMessages']) { should have(2).items }
      end

      describe 'GET /games/{id} parameters' do
        subject { operation['parameters'][0] }

        its(['name']) { should eq 'id' }
        its(['paramType']) { should eq 'path' }
        its(['type']) { should eq 'string' }
        its(['required']) { should be true }
        its(['allowMultiple']) { should be false }
        its(['description']) { should eq 'Game id' }
      end

      describe 'GET /games/{id} validation error response' do
        subject { operation['responseMessages'][1] }

        its(['code']) { should eq 422 }
        its(['message']) { should eq 'Game ids must be integers' }
        its(['responseModel']) { should eq 'DiceOfDebt::API::Error' }
      end
    end
  end
end
