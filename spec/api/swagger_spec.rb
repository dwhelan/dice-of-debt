require_relative 'api_spec_helper'

module DiceOfDebt
  describe 'Swagger' do
    include_context 'api test'

    before { get '/swagger.json' }

    describe '/' do
      subject { json }

      it { expect(status).to eq 200 }

      its([:swagger])  { should eq '2.0' }
      its([:host])     { should be_nil }
      its([:basePath]) { should be_nil }
      its([:schemes])  { should eq ['http'] }
      its([:consumes]) { should eq ['application/vnd.api+json'] }
      its([:produces]) { should eq ['application/vnd.api+json'] }

      describe 'info' do
        let(:info) { json[:info] }
        subject    { info }

        its([:version])     { should eq 0.1 }
        its([:title])       { should eq 'Dice of Debt' }
        its([:description]) { should eq 'An API for the Dice of Debt game.' }

        describe 'contact' do
          subject { info[:contact] }

          its([:name])  { should eq 'Declan Whelan' }
          its([:email]) { should eq 'declan@leanintuit.com' }
          its([:url])   { should eq 'http://leanintuit.com' }
        end

        describe 'license' do
          subject { info[:license] }

          its([:name]) { should eq 'MIT' }
          its([:url])  { should eq 'https://opensource.org/licenses/MIT' }
        end
      end
    end

    describe 'paths' do
      let(:paths) { json[:paths] }

      describe '/games' do
        let(:games) { paths[:'/games'] }

        describe 'get' do
          let(:get_games) { games[:get] }
          subject { games[:get] }

          its([:description]) { should eq 'Get all games.' }

          describe 'responses' do
            let(:responses) { get_games[:responses] }

            describe '200' do
              subject { responses[:'200'] }
              its([:summary])     { should eq 'A list of games.' }
              its([:description]) { should eq 'A list of games.' }
            end
          end
        end
      end
    end
  end
end
