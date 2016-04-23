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

      describe 'properties' do
        let(:properties) { definition[:properties] }

        describe 'id' do
          subject { properties[:id] }

          its([:type])    { should eq 'string' }
          its([:example]) { should eq '1' }
        end

        describe 'type' do
          subject { properties[:type] }

          its([:type])    { should eq 'string' }
          its([:example]) { should eq 'game' }
        end
      end
    end

    describe '/games' do
      let(:games) { json[:paths][:'/games'] }
      let(:responses) { operation[:responses] }
      subject { operation }

      describe 'get' do
        let(:operation) { games[:get] }

        its([:tags])        { should eq ['Games'] }
        its([:summary])     { should eq 'Get all games.' }
        its([:description]) { should eq 'Get all games.' }

        describe 'responses' do
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

      describe 'post' do
        let(:operation) { games[:post] }

        its([:tags])        { should eq ['Games'] }
        its([:summary])     { should eq 'Create a game.' }
        its([:description]) { should eq 'Create a game.' }

        describe 'responses' do
          describe '201' do
            subject { responses[:'201'] }
            its([:summary])     { should eq 'The game just created.' }
            its([:description]) { should eq 'The created game including any automatically created properties.' }

            describe 'schema' do
              subject { responses[:'201'][:schema] }
              its([:type])       { should eq 'object' }
              its([:properties]) { should eq data: { type: 'object', :$ref => '#/definitions/Game' } }
            end
          end
        end
      end
    end
  end
end
