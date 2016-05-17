require_relative 'api_spec_helper'
require 'rspec/collection_matchers'

module DiceOfDebt
  describe API do
    include_context 'api test'

    subject { last_response }

    let(:game1) { { games: { id: '1' } } }

    xdescribe 'GET /games/1/iterations' do
      before { get '/games/1/iterations' }

      it { expect_data 200 }

      subject { data[0] }

      its([:id])    { should eq '1' }
      its([:type])  { should eq 'iteration' }
      its([:value]) { should eq 0 }
      its([:debt])  { should eq 0 }
      its([:score]) { should eq 0 }
    end

    describe 'POST /rolls with no specified rolls' do
      let(:roll) { { type: 'roll', relationships: { game: { data: { type: 'game', id: '1' } } } } }
      before { allow(RandomRoller).to receive(:roll) { 6 } }
      before { post '/rolls', { data: roll }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json' }

      it { expect_data 201 }
      it { expect(headers['Location']).to eq '/rolls/1' }

      subject { data }

      its([:id])   { should eq '1' }
      its([:type]) { should eq 'roll' }

      describe 'attributes' do
        subject { data[:attributes] }

        its([:value]) { should eq [6, 6, 6, 6, 6, 6, 6, 6] }
        its([:debt])  { should eq [6, 6, 6, 6] }
      end

      describe 'resulting game' do
        before { get '/games/1' }

        xdescribe 'included' do
          subject { data[:included] }

          its([:value]) { should eq [6, 6, 6, 6, 6, 6, 6, 6] }
          its([:debt])  { should eq [6, 6, 6, 6] }
        end
      end
    end
  end
end
