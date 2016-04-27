module DiceOfDebt
  class API
    module IterationRepresenter
      include ResourcePresenter

      type 'iteration'

      property :value
    end

    module IterationDocumentRepresenter
      include ResourcePresenter

      resource_presenter IterationRepresenter
    end

    resource :games do
      route_param :id do
        post 'iterations' do
          if game = find_game(params[:id])
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
