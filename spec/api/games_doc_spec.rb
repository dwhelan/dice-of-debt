require_relative 'api_spec_helper'
require 'rspec/matchers'

module DiceOfDebt
  describe 'Swagger docs' do
    include_context 'api test'

    before { get '/swagger_doc.json' }

    describe 'Game definition' do
      let(:definition) { json[:definitions][:game] }
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
      let(:parameters) { operation[:parameters] }

      subject { operation }

      describe 'get' do
        let(:operation) { games[:get] }

        its([:tags])        { should eq ['games'] }
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
              its([:properties]) { should eq data: { type: 'array', items: { :$ref => '#/definitions/game' } } }
            end
          end
        end
      end

      describe 'post' do
        let(:operation) { games[:post] }

        its([:tags])        { should eq ['games'] }
        its([:summary])     { should eq 'Create a new game.' }
        its([:description]) { should eq 'Create a new game.' }

        describe 'parameters' do
          subject { parameters[0] }

          its([:in])          { should eq 'body' }
          its([:required])    { should be true }
          its([:description]) { should eq 'Game to add.' }

          describe 'schema' do
            subject { parameters[0][:schema] }
            its([:type])       { should eq 'object' }
            its([:properties]) { should eq data: { type: 'object', :$ref => '#/definitions/new_game' } }
          end
        end

        describe 'responses' do
          describe '201' do
            subject { responses[:'201'] }
            its([:summary])     { should eq 'The game just created.' }
            its([:description]) { should eq 'The created game including any automatically created properties.' }

            describe 'schema' do
              subject { responses[:'201'][:schema] }
              its([:type])       { should eq 'object' }
              its([:properties]) { should eq data: { type: 'object', :$ref => '#/definitions/game' } }
            end

            describe 'Location header' do
              subject { responses[:'201'][:headers][:Location] }
              its([:type])        { should eq 'string' }
              its([:description]) { should eq 'The URI of the new game.' }
            end
          end
        end
      end
    end
  end
end
