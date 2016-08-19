module DiceOfDebt
  class API
    resource :swagger do
      get do
        YAML.load_file('./api/swagger.yaml')
      end
    end
  end
end
