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

    xdescribe 'GET /games/1/iterations/1' do
      before { get '/games/1/iterations/1' }

      it { expect_data 200 }

      subject { data }

      its([:id])    { should eq '1' }
      its([:type])  { should eq 'iteration' }
      its([:value]) { should eq 0 }
      its([:debt])  { should eq 0 }
      its([:score]) { should eq 0 }
    end

    xdescribe 'GET /games/1/iterations/9999' do
      before { get '/games/1/iterations/9999' }

      it { expect_error 404 }

      subject { error }

      its([:status]) { should eq '404' }
      its([:title])  { should eq 'Could not find iteration' }
      its([:detail]) { should eq 'Could not find an iteration with id 9999' }
      its([:source]) { should eq parameter: 'id' }
    end

    xdescribe 'GET /games/foo' do
      before { get '/games/foo' }

      it { expect_error 422 }

      subject { error }

      its([:status]) { should eq '422' }
      its([:title])  { should eq 'Invalid game id' }
      its([:detail]) { should eq "The provided game id 'foo' should be numeric" }
      its([:source]) { should eq parameter: 'id' }
    end

    xdescribe 'POST /games/iterations' do
      before { post '/games/iterations', { data: {} }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json' }

      it { expect_data 201 }
      it { expect(headers['Location']).to match '/games/\d+' }

      subject { data }

      its([:id])         { should match '\d+' }
      its([:type])       { should eq 'game' }
      its([:value_dice]) { should eq 8 }
      its([:debt_dice])  { should eq 4 }
    end
  end
end