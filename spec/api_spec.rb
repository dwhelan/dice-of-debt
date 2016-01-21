require 'spec_helper'
require 'rack/test'
require_relative '../api'

module DiceOfDebt
  describe API do
    include Rack::Test::Methods

    def app
      API
    end

    subject { last_response }
    let(:headers) { last_response.headers }

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
