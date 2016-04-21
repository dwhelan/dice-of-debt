require 'sinatra'
require 'sinatra/swagger-exposer/swagger-exposer'

module DiceOfDebt
  # The web application class
  class App < Sinatra::Base

    set :allow_origin, :any
    enable :cross_origin

    register Sinatra::SwaggerExposer

    general_info(
        {
            version: '0.0.1',
            title: 'My app',
            description: 'My wonderful app',
            license: {
                name: 'MIT',
                url: 'http://opensource.org/licenses/MIT'
            }
        }
    )

    type 'Status',
         {
             :properties => {
                 :status => {
                     :type => String,
                     :example => 'OK',
                 },
             },
             :required => [:status]
         }

    endpoint_description 'Base method to ping'
    endpoint_response 200, 'Status', 'Standard response'
    endpoint_tags 'Ping'

    get '/' do
      ''
    end
  end
end
