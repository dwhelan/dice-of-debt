require_relative 'api_spec_helper'

module DiceOfDebt
  xdescribe 'Swagger docs' do
    include_context 'api test'

    specify 'root docs' do
      get '/swagger_doc'

      expect(status).to eq 200
      expect(json['apiVersion']).to eq '0.1'
      expect(json['swaggerVersion']).to eq '1.2'
      expect(json['produces']).to eq ['application/vnd.api+json']
      expect(json['apis'].size).to eq 1
      expect(json['apis'][0]['path']).to eq '/games'
      expect(json['apis'][0]['description']).to eq 'Game operations'
      expect(json['apis'][0]['operations']).to be_nil
    end
  end
end
