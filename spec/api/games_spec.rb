require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'
    include_context 'populate database'

    subject { last_response }

    let(:game1) { { games: { id: '1' } }    }

    specify 'get all games' do
      get '/games'

      expect_data(200)
      expect(data.length).to eq 1
      expect(data[0]['type']).to eq 'game'
      expect(data[0]['id']).to eq '1'
      expect(data[0]['value_dice']).to eq 8
    end

    describe 'get game' do
      specify 'when game is found' do
        get '/games/1'

        expect_data(200)
        expect(data['type']).to eq 'game'
        expect(data['id']).to eq '1'
      end

      specify 'when game is not found' do
        get '/games/9999'

        expect_error(404)
        expect(error['title']).to eq 'Not Found'
        expect(error['detail']).to eq 'Could not find a game with id 9999'
        expect(error['source']['parameter']).to eq 'id'
      end

      specify 'when game id is invalid' do
        get '/games/foo'

        expect_error(400)
        expect(error['title']).to  eq 'id is invalid'
        expect(error['detail']).to eq 'id is invalid'
        expect(error['source']['parameter']).to eq 'id'
      end
    end

    describe 'Create game' do
      specify 'with a valid game' do
        request_data = { data: { } }
        post '/games', request_data.to_json, {'CONTENT_TYPE' => 'application/vnd.api+json'}

        expect_data(201)
        expect(headers['Location']).to eq '/games/2'

        expect(data['type']).to eq 'game'
        expect(data['id']).to eq '2'
      end
    end
  end
end
