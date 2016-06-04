require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'

    subject { last_response }

    let(:game1) { { games: { id: '1' } } }

    xdescribe 'GET /iterations' do
      let(:roll) { { type: 'roll', relationships: { game: { data: { type: 'game', id: '1' } } } } }
      before { post '/rolls', { data: roll }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json' }
      before { get '/iterations?game_id=1' }

      subject { data[0] }

      it { expect_data 200 }
      it { expect(data).to be_an Array }
      it { expect(data).to have(1).iteration }

      # its([:id])    { should eq '1' }
      # its([:type])  { should eq 'iteration' }
      # its([:value]) { should eq 0 }
      # its([:debt])  { should eq 0 }
      # its([:score]) { should eq 0 }
    end
  end
end
