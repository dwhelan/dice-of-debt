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
tags:
  -
    name: Games
    description: Everything about games.
definitions:
  Game:
    type: object
    properties:
      id:
        type: string
        example: '1'
paths:
  /games:
    get:
      tags:
        - Games
      description: Get all games.
      responses:
        '200':
          summary: A list of games.
          description: A list of games.
          schema:
            type: object
            properties:
              data:
                type: array
                items:
                  $ref: '#/definitions/Game'
        eos
      end
    end
  end
end
