module DiceOfDebt
  class API
    module IterationRepresenter
      include ResourceRepresenter

      property :type, getter: ->(_) { 'game' }
      property :id,   getter: ->(_) { id.to_s }

      property :value
      property :debt
      property :score
    end

    # resource :iterations do
    #   post do
    #     game_id = params['data']['relationships']['game']['data']['id']
    #     game = find_game(game_id)
    #     # game = find_game(params[:game_id])
    #     if game
    #       game.roll
    #       iteration = game.iteration
    #       game.end_iteration
    #       Persistence::ROM.game_repository.update(game)
    #       IterationRepresenter.as_document(iteration)
    #     end
    #   end
    #
    #   get do
    #     game = find_game(params[:game_id])
    #     IterationRepresenter.as_document(game.iterations)
    #   end
    # end
  end
end
