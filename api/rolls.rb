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
        game = find_game(params[:game_id])
        if game
          fixed_rolls = params['data']['attributes'] || {}
          roll = GamePlayer.new(game).roll(fixed_rolls)

          header 'Location', "/rolls/#{roll.id}"
          RollRepresenter.as_document(roll)
        end
      end
    end
  end
end
