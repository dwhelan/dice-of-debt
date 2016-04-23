require_relative 'api_spec_helper'

module DiceOfDebt
  describe API do
    include_context 'api test'

    subject { error }

    describe 'GET /bad_path' do
      before { get '/foo' }

      it { expect_error(404) }

      its([:status]) { should eq '404' }
      its([:title])  { should eq 'Invalid URI' }
      its([:detail]) { should eq 'Invalid URI' }
      its([:source]) { should be_nil }
    end

    describe 'POST /errors' do
      before { post '/errors', { data: {} }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json' }

      it { expect_error(500) }

      its([:status]) { should eq '500' }
      its([:title])  { should eq 'Internal Server Error' }
      its([:detail]) { should eq 'Internal Server Error' }
      its([:source]) { should be_nil }
    end
  end
end
