require_relative 'api_spec_helper'
require 'rspec/matchers'

# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/LineLength
module DiceOfDebt
  describe 'Swagger docs' do
    include_context 'api test'

    before { get '/swagger_doc.json' }

    describe 'definitions' do
      describe 'Game definition' do
        let(:definition) { json[:definitions][:game] }

        it { expect(definition[:type]).to eq 'object' }

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

          describe 'type' do
            subject { properties[:type] }

            its([:type])    { should eq 'string' }
            its([:example]) { should eq 'game' }
          end
        end
      end

      describe 'Game attributes' do
        let(:definition) { json[:definitions][:game_attributes] }

        it { expect(definition[:type]).to eq 'object' }

        describe 'properties' do
          let(:properties) { definition[:properties] }

          describe 'score' do
            subject { properties[:score] }

            its([:type])    { should eq 'integer' }
            its([:example]) { should eq 0 }
          end

          describe 'value_dice' do
            subject { properties[:value_dice] }

            its([:type])    { should eq 'integer' }
            its([:example]) { should eq 8 }
          end

          describe 'debt_dice' do
            subject { properties[:debt_dice] }

            its([:type])    { should eq 'integer' }
            its([:example]) { should eq 4 }
          end
        end
      end
    end

    describe 'paths' do
      let(:responses)  { operation[:responses] }
      let(:parameters) { operation[:parameters] }

      subject { operation }

      describe 'GET /games' do
        let(:games) { json[:paths][:'/games'] }

        describe 'get' do
          let(:operation) { json[:paths][:'/games'][:get] }

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
      end

      describe 'POST /games' do
        let(:operation) { json[:paths][:'/games'][:post] }

        its([:tags])        { should eq ['games'] }
        its([:summary])     { should eq 'Create a new game.' }
        its([:description]) { should eq 'Create a new game.' }

        it { expect(parameters).to be_nil }

        describe 'responses' do
          describe '201' do
            subject { responses[:'201'] }
            its([:summary])     { should_not be_blank }
            its([:description]) { should_not be_blank }

            describe 'schema' do
              subject { responses[:'201'][:schema] }
              its([:type])       { should eq 'object' }
              its([:properties]) { should eq data: { type: 'object', :$ref => '#/definitions/game' } }
            end

            describe 'Location header' do
              subject { responses[:'201'][:headers][:Location] }
              its([:type])        { should eq 'string' }
              its([:description]) { should_not be_blank }
            end
          end
        end
      end

      describe 'GET /games/{id}' do
        let(:operation) { json[:paths][:'/games/{id}'][:get] }

        its([:tags])        { should eq ['games'] }
        its([:summary])     { should should_not be_blank }
        its([:description]) { should should_not be_blank }

        describe 'parameters' do
          subject { parameters[0] }

          its([:name])        { should eq 'id' }
          its([:in])          { should eq 'path' }
          its([:required])    { should be true }
          its([:description]) { should_not be_blank }
          its([:type])        { should eq 'string' }
        end

        describe 'responses' do
          describe '200' do
            subject { responses[:'200'] }
            its([:description]) { should_not be_blank }

            describe 'schema' do
              subject { responses[:'200'][:schema] }
              its([:type])       { should eq 'object' }
              its([:properties]) { should eq data: { type: 'object', :$ref => '#/definitions/game' } }
            end
          end

          describe '404' do
            subject { responses[:'404'] }
            its([:description]) { should_not be_blank }

            describe 'schema' do
              subject { responses[:'404'][:schema] }
              its([:type])       { should eq 'object' }
              its([:properties]) { should eq errors: { type: 'array', items: { :$ref => '#/definitions/not_found_error' } } }
            end
          end
        end
      end
    end
  end
end
