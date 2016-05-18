module DiceOfDebt
  class API
    module RollRepresenter
      include ResourceRepresenter

      type :roll

      attributes do
        property :value, getter: ->(_) { rolls[:value] }
        property :debt,  getter: ->(_) { rolls[:debt] }
      end
    end

    resource :rolls do
      post do
        game_id = params['data']['relationships']['game']['data']['id']
        game = find_game(game_id)
        if game
          fixed_rolls = params['data']['attributes'] || {}
          roll = game.iteration.roll(fixed_rolls)
          header 'Location', "/rolls/#{roll.id}"
          RollRepresenter.as_document(roll)
        end
      end
    end
  end
end
