module DiceOfDebt
  class API < Grape::API
    route :any, '*path' do
      error(status: 404, title: 'Invalid URI')
    end
  end
end
