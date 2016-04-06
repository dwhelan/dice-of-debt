require_relative 'api_spec_helper'

module DiceOfDebt
  describe API, :aggregate_failures do
    include_context 'api test'

    specify 'GET /foo' do
      get '/foo'

      expect_error(404)
      expect(error['title']).to eq 'Invalid URI'
    end

    specify 'POST /errors' do
      post '/errors'
      request_data = { data: { } }
      post '/errors', request_data.to_json, {'CONTENT_TYPE' => 'application/vnd.api+json'}

      expect_error(500)
      expect(error['title']).to eq 'Internal Server Error'
    end
  end
end
