module DiceOfDebt
  class API
    resource :swagger_doc do
      get do
        YAML.load_file('./api/swagger_doc.yaml')
      end
    end
  end
end
