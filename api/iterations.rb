module DiceOfDebt
  class API
    module IterationRepresenter
      include ResourcePresenter

      type 'iteration'

      property :value
    end

    module IterationArrayRepresenter
      include ResourceArrayPresenter

      resource_presenter IterationRepresenter
    end

    module IterationDocumentRepresenter
      include ResourcePresenter

      resource_presenter IterationRepresenter
    end

    resource :games do
      route_param :id do
        post 'iterations' do
          game = find_game(params[:id])
          if game
            game.roll_value_dice
            game.roll_debt_dice
            iteration = game.iteration
            game.end_iteration
            Persistence.game_repository.update(game)
            present iteration, with: IterationDocumentRepresenter
          end
        end

        get 'iterations' do
        end
      end
    end
  end
end
