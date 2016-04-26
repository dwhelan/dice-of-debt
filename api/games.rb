module DiceOfDebt
  class API
    module GamePresenter
      include ResourcePresenter

      type 'game'

      property :value_dice, getter: ->(_) { value_dice.count }
      property :debt_dice,  getter: ->(_) { debt_dice.count  }
    end

    module GameDocumentPresenter
      include ResourcePresenter

      resource_presenter GamePresenter
    end

    module GameArrayDocumentPresenter
      include ResourceArrayPresenter

      resource_presenter GamePresenter
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
        game = GameDocumentPresenter.represent(Game.new).from_json request.body.read
        game = repository.create(game)
        header 'Location', "/games/#{game.id}"
        present game, with: GameDocumentPresenter
      end

      params do
        requires :id
      end

      route_param :id do
        get do
          id = params[:id]
          # rubocop:disable Lint/AssignmentInCondition
          if id !~ /\d+/
            error(
              status: 422,
              title: 'Invalid game id',
              detail: "The provided game id '#{id}' should be numeric",
              source: { parameter: :id }
            )
          elsif game = repository.with_id(id)
            present game, with: GameDocumentPresenter
          else
            error(
              status: 404,
              title: 'Could not find game',
              detail: "Could not find a game with id #{id}",
              source: { parameter: :id }
            )
          end
        end
      end
    end
  end
end
