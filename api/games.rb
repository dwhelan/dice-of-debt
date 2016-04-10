module DiceOfDebt
  class API

    module GamePresenter
      include ResourcePresenter

      type 'game'

      property :value_dice, getter: ->(_) { value_dice.count }
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

      desc 'Get all games.'
      get do
        present repository.all, with: GameArrayDocumentPresenter
      end

      desc 'Get a game.' do
        failure [[400, 'id is invalid', Error]]
      end
      params do
        requires :id, type: Integer, desc: 'Game id.'
      end

      route_param :id do
        get do
          if game = repository.with_id(params[:id])
            present game, with: GameDocumentPresenter
          else
            error(status: 404, detail: "Could not find a game with id #{params[:id]}.", source: {parameter: :id})
          end
        end
      end

      desc 'Create a game.'
      post do
        game = GameDocumentPresenter.represent(Game.new).from_json request.body.string
        present repository.create(game), with: GameDocumentPresenter
        header 'Location', "/games/#{game.id}"
      end
    end
  end
end
