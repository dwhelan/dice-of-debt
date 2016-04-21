require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'

    specify 'Returns the response CORS headers' do
      get '/', nil, 'HTTP_ORIGIN' => '*'

      expect(headers['Access-Control-Allow-Origin']).to eq '*'
      expect(headers['Access-Control-Allow-Methods']).to eq 'HEAD, OPTIONS, GET, POST, PATCH, DELETE'
      expect(headers['Access-Control-Allow-Headers']).to eq 'Content-Type'
    end
  end
end
