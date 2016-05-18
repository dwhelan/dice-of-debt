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

      relationships do
        collection :iterations, extend: IterationRepresenter
        collection :rolls, extend: RollRepresenter
      end

      def self.as_document(resource)
        if resource
          resource.extend(self)
          { 'data' => resource.to_hash }
        end
      end

      # def self.as_document_array(resources)
      #   if resource
      #     resource.extend(self)
      #     { 'data' => resource.to_hash }
      #   end
      # end

      module DocumentArray
        include ResourceArrayPresenter

        resource_presenter GamePresenter
      end
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
        present repository.all, with: GamePresenter::DocumentArray
        # GamePresenter.as_document_array(repository.all)
      end

      post do
        game = repository.create
        header 'Location', "/games/#{game.id}"
        GamePresenter.as_document(game)
      end

      route_param :id do
        get do
          game = find_game(params[:id])
          GamePresenter.as_document(game)
        end
      end
    end
  end
end
