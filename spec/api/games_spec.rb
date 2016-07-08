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

      specify 'should have a link to the game resource' do
        expect(data[:links][:self]).to eq "http://example.org/games/#{data[:id]}"
      end

      specify 'no relationships provided' do
        expect(data[:relationships]).to be_nil
      end

      specify 'no included resources' do
        expect(data[:included]).to be_nil
      end
    end

    describe 'get all games' do
      before { get '/games' }

      it { expect_data 200 }

      subject { data[0] }

      its([:id])   { should eq '1' }
      its([:type]) { should eq 'game' }

      it { expect(data[0][:attributes][:iterations]).to be_nil }
    end

    describe 'get a newly created game' do
      before { get '/games/1' }

      it { expect_data 200 }

      include_examples :initial_game

      it { expect(data[:attributes][:iterations]).to be_empty }
    end

    describe 'get a partially completed game' do
      before do
        insert_data :iterations, id: 420, game_id: 1, value: 12, debt: 9, status: 'complete'
        get '/games/1'
      end

      after do
        delete_data :iterations, game_id: 1
      end

      it { expect_data 200 }

      include_examples :initial_game

      it { expect(data[:attributes][:iterations].size).to eq 1 }
      it { expect(data[:attributes][:status]).to eq 'started' }

      describe 'iteration' do
        subject { data[:attributes][:iterations][0] }

        it { expect(subject).to_not have_key :id }

        its([:value])  { should eq 12 }
        its([:debt])   { should eq 9 }
        its([:score])  { should eq 3 }
        its([:status]) { should eq 'complete' }
      end
    end

    describe 'get a complete game' do
      before do
        (420..429).each do |id|
          insert_data :iterations, id: id, game_id: 1, value: 12, debt: 9, status: 'complete'
        end

        get '/games/1'
      end

      after do
        delete_data :iterations, game_id: 1
      end

      it { expect_data 200 }

      include_examples :initial_game

      it { expect(data[:attributes][:iterations].size).to eq 10 }
      it { expect(data[:attributes][:status]).to eq 'complete' }
    end

    describe 'GET a game using a non-existent id' do
      before { get '/games/9999' }

      include_examples 'GET using a non-existent resource id', 'game'
    end

    describe 'GET a game using an invalid id' do
      before { get '/games/foo' }

      include_examples 'GET using an invalid resource id', 'game'
    end

    describe 'POST /games' do
      before { post '/games', { data: {} }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json' }

      it { expect_data 201 }
      it { expect(headers['Location']).to match "http://example.org/games/#{data['id']}" }

      include_examples :initial_game
    end
  end
end
