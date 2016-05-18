module DiceOfDebt
  class API
    module IterationRepresenter
      include ResourcePresenter

      type 'iteration'

      property :value
      property :debt
      property :score
    end

    resource :games do
      route_param :game_id do
        resource :iterations do
          post do
            game = find_game(params[:game_id])
            if game
              game.roll
              iteration = game.iteration
              game.end_iteration
              Persistence.game_repository.update(game)
              IterationRepresenter.as_document(iteration)
            end
          end

          get do
            game = find_game(params[:game_id])
            IterationRepresenter.as_document(game.iteration)
          end

          route_param :id do
            get do
              game = find_game(params[:game_id])
              IterationRepresenter.as_document(game.iteration)
            end
          end
        end
      end
    end
  end
end
