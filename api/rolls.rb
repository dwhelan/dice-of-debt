module DiceOfDebt
  class API
    resource :rolls do
      post do
        game = find_resource('game', :game_id)
        if game
          fixed_rolls = params['data'] && params['data']['attributes'] || {}
          roll = Player.new(game).roll_dice(fixed_rolls)

          header 'Location', "#{request.base_url}/rolls/#{roll.id}"
          RollRepresenter.as_document(roll, request)
        end
      end

      get '/:id' do
        roll = find_resource('roll')
        RollRepresenter.as_document(roll, request) if roll
      end
    end

    module RollRepresenter
      include ResourceRepresenter

      property :type, getter: -> _ { 'roll' }
      property :id,   getter: -> _ { id.to_s }

      attributes do
        property :value, getter: -> _ { rolls[:value] }
        property :debt,  getter: -> _ { rolls[:debt] }
      end

      links do
        property :self, getter: -> _ { "#{base_url}/rolls/#{id}" }
        property :game, getter: -> _ { "#{base_url}/games/#{iteration.game.id}" }
      end
    end
  end
end
