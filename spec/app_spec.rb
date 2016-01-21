require 'spec_helper'
require 'rack/test'

module DiceOfDebt
  describe App do
    include Rack::Test::Methods

    def app
      App
    end

    subject { last_response }
    let(:headers) { last_response.headers }

    describe 'GET' do
      before { get '/' }

      its(:body) { should eq '' }
      its(:status) { should eq 200 }
    end
  end
end
