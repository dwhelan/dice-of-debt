require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'

    subject { last_response }

    let(:game1) { { games: { id: '1' } } }
    let(:roll)  { { type: 'roll' } }

    before { allow(RandomRoller).to receive(:roll) { 6 } }
    before { post '/rolls?game_id=1', { data: roll }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json' }

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

    describe 'POST /rolls with no specified rolls' do
      it { expect_data 201 }
      it { expect(headers['Location']).to eq "http://example.org/rolls/#{data[:id]}" }

      include_examples 'initial roll'
    end

    describe 'get a newly created roll' do
      before { get "rolls/#{data[:id]}" }

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
