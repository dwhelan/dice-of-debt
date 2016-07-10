require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'

    subject { last_response }

    let(:game1) { { games: { id: '1' } } }
    let(:roll)  { { type: 'roll' } }

    before { allow(RandomRoller).to receive(:roll) { 6 } }

    def post_roll(data = nil, game_id = 1)
      post "/rolls?game_id=#{game_id}", data.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json'
    end

    shared_examples 'initial roll' do
      subject { data }

      its([:id])   { should match '\d+' }
      its([:type]) { should eq 'roll' }

      describe 'attributes' do
        subject { data[:attributes] }

        its([:value]) { should eq %w(6 6 6 6 6 6 6 6) }
        its([:debt])  { should eq %w(6 6 6 6) }
      end

      specify 'should have a link to the roll resource' do
        expect(data[:links][:self]).to eq "http://example.org/rolls/#{data[:id]}"
      end

      specify 'should have a link to the game resource' do
        expect(data[:links][:game]).to eq 'http://example.org/games/1'
      end
    end

    describe 'POST /rolls' do
      shared_examples 'newly created roll' do
        include_examples 'initial roll'

        it { expect_data 201 }
        it { expect(headers['Location']).to eq "http://example.org/rolls/#{data[:id]}" }
      end

      describe 'with no data' do
        before { post_roll '' }

        include_examples 'newly created roll'
      end

      describe 'with no data attributes' do
        before { post_roll data: {} }

        include_examples 'newly created roll'
      end

      describe 'with no specified rolls' do
        before { post_roll data: roll }

        include_examples 'newly created roll'
      end

      xdescribe 'with a non-existent game id' do
        before { post_roll data: roll }

        include_examples 'GET using a non-existent resource id', 'game', 'game_id'
      end

      describe 'for a complete game should fail' do
        before do
          10.times do
            post_roll
          end

          post_roll
        end

        it { expect_error 422 }

        subject { error }

        its([:status]) { should eq '422' }
        its([:title])  { should eq 'Cannot roll dice when the game is complete' }
        its([:detail]) { should eq 'Cannot roll dice when the game is complete' }
        its([:source]) { should be_nil }
      end
    end

    describe 'get a newly created roll' do
      before do
        post_roll
        get "rolls/#{data[:id]}"
      end

      it { expect_data 200 }

      include_examples 'initial roll'
    end

    describe 'GET a roll using a non-existent id' do
      before { get '/rolls/9999' }

      include_examples 'GET using a non-existent resource id', 'roll'
    end

    describe 'GET a roll using an invalid id' do
      before { get '/rolls/foo' }

      include_examples 'GET using an invalid resource id', 'roll'
    end
  end
end
