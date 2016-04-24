require 'grape'
require 'grape-roar'

module DiceOfDebt
  class API
    resource :swagger_doc do
      get do
        YAML.load <<-eos
---
swagger: '2.0'
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
    name: games
    description: Everything about games.
definitions:
  game:
    type: object
    properties:
      id:
        type: string
        example: '1'
      type:
        type: string
        example: 'game'
  new_game:
    type: object
    properties:
      foo:
        type: string
        example: '1'
paths:
  /games:
    get:
      tags:
        - games
      summary: Get all games.
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
                  $ref: '#/definitions/game'
    post:
      tags:
        - games
      summary: Create a new game.
      description: Create a new game.
      parameters:
        - name: body
          in: body
          description: Game to add.
          required: true
          schema:
            type: object
            properties:
              data:
                type: object
                $ref: '#/definitions/new_game'
      responses:
        '201':
          summary: The game just created.
          description: The created game including any automatically created properties.
          schema:
            type: object
            properties:
              data:
                type: object
                $ref: '#/definitions/game'
        eos
      end
    end
  end
end
