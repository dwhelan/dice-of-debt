module DiceOfDebt
  class API
    module RollRepresenter
      include ResourceRepresenter

      property :type, getter: ->(_) { 'roll' }
      property :id,   getter: ->(_) { id.to_s }

      attributes do
        property :value, getter: ->(_) { rolls[:value] }
        property :debt,  getter: ->(_) { rolls[:debt] }
      end

      links do
        property :self, getter: ->(_) { "#{base_url}/rolls/#{id}" }
        property :game, getter: ->(_) { "#{base_url}/games/#{iteration.game.id}" }
      end
    end

    resource :rolls do

      helpers do
        def find_roll(id)
          find_resource('roll', id)
        end
      end

      post do
        game = find_game(params[:game_id])
        if game
          fixed_rolls = params['data']['attributes'] || {}
          roll = Player.new(game).roll_dice(fixed_rolls)

          header 'Location', "#{request.base_url}/rolls/#{roll.id}"
          RollRepresenter.as_document(roll, request)
        end
      end

      route_param :id do
        get do
          roll = find_roll(params[:id])
          RollRepresenter.as_document(roll, request)
        end
      end
    end
  end
end
