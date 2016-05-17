module DiceOfDebt
  class API
    module RollRepresenter
      include ResourcePresenter

      type :roll

      nested :attributes do
        property :value, getter: ->(_) { rolls[:value] }
        property :debt,  getter: ->(_) { rolls[:debt] }
      end
    end

    module RollArrayRepresenter
      include ResourceArrayPresenter

      resource_presenter RollRepresenter
    end

    module RollDocumentRepresenter
      include ResourcePresenter

      resource_presenter RollRepresenter
    end

    module RollArrayDocumentRepresenter
      include ResourceArrayPresenter

      resource_presenter RollRepresenter
    end

    resource :rolls do
      post do
        game_id = params['data']['relationships']['game']['data']['id']
        game = find_game(game_id)
        if game
          fixed_rolls = params['data']['attributes'] || {}
          roll = game.roll(fixed_rolls)
          header 'Location', "/rolls/#{roll.id}"
          present roll, with: RollDocumentRepresenter
        end
      end\
    end
  end
end
