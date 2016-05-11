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

      type 'roll'

      property :value, getter: ->(_) { rolls[:value] }
      property :debt,  getter: ->(_) { rolls[:debt] }
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

    resource :games do
      route_param :game_id do
        resource :rolls do
          post do
            game = find_game(params[:game_id])
            if game
              roll = Roll.new(game, game.roll(params[:data]))
              header 'Location', "/games/#{game.id}/rolls/#{roll.id}"
              present roll, with: RollDocumentRepresenter
              #   game.roll_value_dice
              #   game.roll_debt_dice
              #   iteration = game.iteration
              #   game.end_iteration
              #   Persistence.game_repository.update(game)
              #   present iteration, with: RollDocumentRepresenter
            end
          end

          # params do
          #   requires :id
          # end
          #
          # route_param :id do
          #   get do
          #     game = find_game(params[:game_id])
          #     if game
          #       present game.iterations, with: RollArrayDocumentRepresenter
          #     end
          #   end
          # end
        end
      end
    end
  end
end
