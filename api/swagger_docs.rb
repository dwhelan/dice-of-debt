require 'grape'
require 'grape-roar'

module DiceOfDebt
  class API
    resource :swagger_doc do
      get do
        YAML.load <<-eos
---
swagger: "2.0"
schemes:
  - http
consumes:
  - application/vnd.api+json
produces:
  - application/vnd.api+json
info:
  version: 0.1
  title: Dice of Debt
  description: An API for the Dice of Debt game.
  contact:
    name: Declan Whelan
    email: declan@leanintuit.com
    url: http://leanintuit.com
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT
paths:
  /games:
    get:
      description: Get all games.
      responses:
        '200':
          summary: A list of games.
          description: A list of games.
        eos
      end
    end
  end
end
