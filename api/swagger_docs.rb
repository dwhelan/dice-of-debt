require 'grape'
require 'grape-roar'

# rubocop:disable Metrics/ClassLength
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
  error_source:
    type: object
    properties:
      parameter:
        type: string
        example: 'id'
  not_found_error:
    type: object
    properties:
      status:
        type: string
        example: '404'
      title:
        type: string
        example: 'Not Found'
      detail:
        type: string
        example: 'Could not find a game with id 123.'
      source:
        type: object
        $ref: '#/definitions/error_source'
  error:
      type: object
      properties:
        status:
          type: string
          example: '404'
        title:
          type: string
          example: 'Could not find the requested game.'
        detail:
          type: string
          example: 'Could not find game with id 456.'
        source:
          type: string
          example: 'TBD.'
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
          headers:
            Location:
              type: string
              description: The URI to the newly created game.
  /games/{id}:
    get:
      tags:
        - games
      summary: Get a game by id.
      description: Get a game by id.
      parameters:
        - name: id
          in: path
          description: The id of the game to get.
          required: true
          type: string
      responses:
        '200':
          description: The requested game.
          schema:
            type: object
            properties:
              data:
                type: object
                $ref: '#/definitions/game'
        '404':
          description: The requested game could not be found.
          schema:
            type: object
            properties:
              errors:
                type: array
                items:
                  $ref: '#/definitions/not_found_error'
        '422':
          description: There was invalid data in the request.
          schema:
            type: object
            properties:
              errors:
                type: array
                items:
                  $ref: '#/definitions/error'
        eos
      end
    end
  end
end
