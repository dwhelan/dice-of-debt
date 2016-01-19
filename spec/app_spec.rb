require 'spec_helper'
require 'rack/test'

module DiceOfDebt
  describe App do
    include Rack::Test::Methods

    def app
      App
    end

    subject { last_response }

    describe 'GET' do
      before { get '/' }

      its(:body) { should eq '' }
      its(:status) { should eq 200 }
    end

    describe 'POST /games' do
      let!(:game) { Game.new }
      before do
        allow(Game).to receive(:new) { game }
        post '/games'
      end

      it { expect(Game).to have_received(:new) }
      its(:status) { should eq 201 }
      its(:body) { should eq game.to_json }
    end
  end
end
