require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'

    subject { last_response }

    let(:game1) { { games: { id: '1' } } }

    describe 'POST /rolls with no specified rolls' do
      let(:roll) { { type: 'roll' } }
      before { allow(RandomRoller).to receive(:roll) { 6 } }
      before { post '/rolls?game_id=1', { data: roll }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json' }

      it { expect_data 201 }
      it { expect(headers['Location']).to match %r{/rolls/\d+} }

      subject { data }

      its([:id])   { should match '\d+' }
      its([:type]) { should eq 'roll' }

      describe 'attributes' do
        subject { data[:attributes] }

        its([:value]) { should eq [6, 6, 6, 6, 6, 6, 6, 6] }
        its([:debt])  { should eq [6, 6, 6, 6] }
      end

      xit 'should be saved' do
        roll_id = data[:id]
        expect(Persistence::ROM.roll_repository.by_id roll_id).to_not be_nil
      end
    end
  end
end
