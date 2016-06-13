require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'

    shared_examples :initial_game do
      subject { data }

      its([:id])   { should match '\d+' }
      its([:type]) { should eq 'game' }

      describe 'attributes' do
        subject { data[:attributes] }

        its([:value_dice]) { should eq 8 }
        its([:debt_dice])  { should eq 4 }
        its([:score])      { should eq 0 }
      end

      describe 'relationships' do
        subject { data[:included] }

        its(:count) { should > 0 }
      end

      describe 'included' do
        subject { data[:included] }

        its(:count) { should > 0 }
      end
    end

    describe 'GET /games' do
      before { get '/games' }

      it { expect_data 200 }

      subject { data[0] }

      its([:id])   { should eq '1' }
      its([:type]) { should eq 'game' }
    end

    describe 'GET /games/1' do
      before { get '/games/1' }

      it { expect_data 200 }

      include_examples :initial_game
    end

    describe 'GET /games/9999' do
      before { get '/games/9999' }

      it { expect_error 404 }

      subject { error }

      its([:status]) { should eq '404' }
      its([:title])  { should eq 'Could not find game' }
      its([:detail]) { should eq 'Could not find a game with id 9999' }
      its([:source]) { should eq parameter: 'id' }
    end

    describe 'GET /games/foo' do
      before { get '/games/foo' }

      it { expect_error 422 }

      subject { error }

      its([:status]) { should eq '422' }
      its([:title])  { should eq 'Invalid game id' }
      its([:detail]) { should eq "The provided game id 'foo' should be numeric" }
      its([:source]) { should eq parameter: 'id' }
    end

    describe 'POST /games' do
      before { post '/games', { data: {} }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json' }

      fit { expect_data 201 }
      it { expect(headers['Location']).to match '/games/\d+' }

      include_examples :initial_game
    end
  end
end
