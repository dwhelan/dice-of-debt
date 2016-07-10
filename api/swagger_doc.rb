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
  - name: games
    description: Everything about games.
  - name: rolls
    description: Everything about rolls.
definitions:
  resource:
    properties:
      id:
        type: string
        readOnly: true
        example: '1'
      type:
        type: string
        readOnly: true
        example: 'game'
  game:
    allOf:
      - $ref: "#/definitions/resource"
    properties:
      attributes:
        $ref: '#/definitions/game_attributes'
        readOnly: true
  roll:
    properties:
      id:
        type: string
        readOnly: true
        example: '1'
      type:
        type: string
        readOnly: true
        example: 'roll'
      attributes:
        $ref: '#/definitions/roll_attributes'
        readOnly: true
  roll_attributes:
    properties:
      value:
        type: array
        items:
            type: string
        example:
          - '1'
          - '6'
          - '4'
          - '1'
          - '3'
          - '3'
          - '2'
          - '5'
      debt:
        type: array
        items:
            type: string
        example:
          - '6'
          - '1'
          - '3'
          - '2'
  game_attributes:
    properties:
      score:
        type: integer
        readOnly: true
        example: 0
      value_dice:
        type: integer
        readOnly: true
        example: 8
      debt_dice:
        type: integer
        readOnly: true
        example: 4
  error_source:
    properties:
      parameter:
        type: string
        readOnly: true
        example: 'id'
  error:
    properties:
      status:
        type: string
        readOnly: true
      title:
        type: string
        readOnly: true
      detail:
        type: string
        readOnly: true
      source:
        $ref: '#/definitions/error_source'
        readOnly: true
  not_found_error:
    allOf:
      - $ref: '#/definitions/error'
    example:
      status: '404'
      title: Not Found
      detail: Could not find a game with id 123.
      source:
        parameter: id
  validation_error:
    allOf:
      - $ref: '#/definitions/error'
    example:
      status: '422'
      title: Invalid game id
      detail: The provided game id 'foo' should be numeric
      source:
        parameter: id
paths:
  /rolls:
    post:
      tags:
        - rolls
      summary: Roll the dice.
      description: Roll the dice with the given values. If any values are missing\
                   then random numbers will be generated.
      parameters:
        - name: game_id
          in: query
          description: The id of the game to roll against.
          required: true
          type: string
        - name: data
          in: formData
          description: The dice rolls.
          required: false
          schema:
            $ref: '#/definitions/roll_attributes'
      responses:
        '201':
          summary: The roll just created.
          description: The roll just created.
          schema:
            type: object
            properties:
              data:
                type: object
                $ref: '#/definitions/roll'
          headers:
            Location:
              type: string
              description: The URI to the newly created roll.
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
          description: The game id provided must be numeric.
          schema:
            type: object
            properties:
              errors:
                type: array
                items:
                  $ref: '#/definitions/validation_error'
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
      responses:
        '201':
          summary: The game just created.
          description: The game just created.
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
          description: The game id provided must be numeric.
          schema:
            type: object
            properties:
              errors:
                type: array
                items:
                  $ref: '#/definitions/validation_error'
        eos
      end
    end
  end
end
