module DiceOfDebt
  class API
    module IterationRepresenter
      include ResourcePresenter

      type 'iteration'

      property :value
      property :debt
      property :score
    end

    module IterationArrayRepresenter
      include ResourceArrayPresenter

      resource_presenter IterationRepresenter
    end

    module IterationDocumentRepresenter
      include ResourcePresenter

      resource_presenter IterationRepresenter
    end

    module IterationArrayDocumentRepresenter
      include ResourceArrayPresenter

      resource_presenter IterationRepresenter
    end

    resource :games do
      route_param :game_id do
        resource :iterations do
          post do
            game = find_game(params[:game_id])
            if game
              game.roll_value_dice
              game.roll_debt_dice
              iteration = game.iteration
              game.end_iteration
              Persistence.game_repository.update(game)
              present iteration, with: IterationDocumentRepresenter
            end
          end

          get do
            game = find_game(params[:game_id])
            if game
              present game.iterations, with: IterationArrayDocumentRepresenter
            end
          end

          route_param :id do
            get do
              game = find_game(params[:game_id])
              present game.iteration, with: IterationDocumentRepresenter if game
            end
          end
        end
      end
    end
  end
end
