require_relative 'api_spec_helper'
require 'rspec/matchers'

module DiceOfDebt
  describe 'Swagger docs' do
    include_context 'api test'

    before { get '/swagger_doc.json' }

    describe 'Game definition' do
      let(:definition) { json[:definitions][:Game] }
      subject { definition }

      its([:type]) { should eq 'object' }

      describe 'id property' do
        subject { definition[:properties][:id] }

        its([:type])    { should eq 'string' }
        its([:example]) { should eq '1' }
      end
    end

    describe '/games' do
      let(:games) { json[:paths][:'/games'] }

      describe 'get' do
        let(:get_games) { games[:get] }
        subject { games[:get] }

        its([:tags])        { should eq ['Games'] }
        its([:description]) { should eq 'Get all games.' }

        describe 'responses' do
          let(:responses) { get_games[:responses] }

          describe '200' do
            subject { responses[:'200'] }
            its([:summary])     { should eq 'A list of games.' }
            its([:description]) { should eq 'A list of games.' }

            describe 'schema' do
              subject { responses[:'200'][:schema] }
              its([:type])       { should eq 'object' }
              its([:properties]) { should eq data: { type: 'array', items: { :$ref => '#/definitions/Game' } } }
            end
          end
        end
      end
    end
  end
end
