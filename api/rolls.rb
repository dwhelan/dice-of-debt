module DiceOfDebt
  class Roll
    attr_reader :id, :rolls

    def initialize(game, rolls)
      self.id    = game.iterations.count
      self.rolls = rolls
    end

    private

    attr_writer :id, :rolls
  end

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
          roll = Roll.new(game, game.roll(params[:data]))
          header 'Location', "/rolls/#{roll.id}"
          present roll, with: RollDocumentRepresenter
        end
      end\
    end
  end
end
