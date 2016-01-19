require 'spec_helper'
require 'rack/test'

module DiceOfDebt
  describe App do
    include Rack::Test::Methods

    def app
      App
    end

    specify 'GET' do
      get '/'

      expect(last_response.body).to eq('')
      expect(last_response.status).to eq 200
    end
  end
end
