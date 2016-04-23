require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'

    specify 'GET /foo' do
      get '/foo'

      expect_error(404)
      expect(error[:status]).to eq '404'
      expect(error[:title]).to eq 'Invalid URI'
      expect(error[:detail]).to eq 'Invalid URI'
      expect(error[:source]).to be_nil
    end

    specify 'POST /errors' do
      post '/errors'
      request_data = { data: {} }
      post '/errors', request_data.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json'

      expect_error(500)
      expect(error[:status]).to eq '500'
      expect(error[:title]).to eq 'Internal Server Error'
      expect(error[:detail]).to eq 'Internal Server Error'
      expect(error[:source]).to be_nil
    end
  end
end
