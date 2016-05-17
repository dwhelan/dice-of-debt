module DiceOfDebt
  class API
    module GamePresenter
      include ResourcePresenter

      type 'game'

      attributes do
        property :value_dice, getter: ->(_) { dice[:value].count }
        property :debt_dice,  getter: ->(_) { dice[:debt].count  }
        property :score
      end

      nested :included do
        collection :iterations, extend: IterationRepresenter, as: nil
      end
    end

    module GameDocumentPresenter
      include ResourcePresenter

      resource_presenter GamePresenter
    end

    module GameArrayDocumentPresenter
      include ResourceArrayPresenter

      resource_presenter GamePresenter
    end

    helpers do
      def find_game(id)
        if valid_game_id?(id)
          error_for_invalid_game_id(id)
        else
          Persistence.game_repository.with_id(id) || error_for_game_not_found(id)
        end
      end

      def valid_game_id?(id)
        id !~ /\d+/
      end

      def error_for_invalid_game_id(id)
        error(
          status: 422,
          title: 'Invalid game id',
          detail: "The provided game id '#{id}' should be numeric",
          source: { parameter: :id }
        )
      end

      def error_for_game_not_found(id)
        error(
          status: 404,
          title: 'Could not find game',
          detail: "Could not find a game with id #{id}",
          source: { parameter: :id }
        )
      end
    end

    resource :games do
      helpers do
        def repository
          Persistence.game_repository
        end
      end

      get do
        present repository.all, with: GameArrayDocumentPresenter
      end

      post do
        game = GameDocumentPresenter.represent(Game.new)
        game = repository.create(game)
        header 'Location', "/games/#{game.id}"
        present game, with: GameDocumentPresenter
      end

      params do
        requires :id
      end

      route_param :id do
        get do
          game = find_game(params[:id])
          present game, with: GameDocumentPresenter if game
        end
      end
    end
  end
end
