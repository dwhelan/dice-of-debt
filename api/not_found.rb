module DiceOfDebt
  class API < Grape::API
    JSON_API_CONTENT_TYPE = 'application/vnd.api+json'

    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end
  end
end
