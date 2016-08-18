module DiceOfDebt
  class API
    require 'grape-cors'

    Grape::CORS::Config.methods.clear
    Grape::CORS::Config.methods.push 'HEAD', 'OPTIONS', 'GET', 'POST', 'PATCH', 'DELETE'

    Grape::CORS.apply!
  end
end
