module DiceOfDebt
  class API
    module BaseGameRepresenter
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def self.included(base)
        base.instance_eval do
          include ResourceRepresenter

          property :type, getter: ->(_) { 'game' }
          property :id,   getter: ->(_) { id.to_s }

          attributes do
            property :value_dice, getter: ->(_) { dice[:value].count }
            property :debt_dice,  getter: ->(_) { dice[:debt].count  }
            property :score
            property :status
          end

          links do
            property :self, getter: ->(_) { "#{base_url}/games/#{id}" }
          end
        end
      end
    end

    module GameSummaryRepresenter
      include BaseGameRepresenter
    end

    module GameRepresenter
      include BaseGameRepresenter

      attributes do
        collection :iterations, extend: IterationRepresenter
      end
    end

    helpers do
      def find_game(id)
        find_resource('game', id)
      end

      def find_resource(type, id)
        if valid_resource_id?(id)
          error_for_invalid_resource_id(type, id)
        else
          Persistence::ROM.repository_for(type).by_id(id) || error_for_resource_not_found(type, id)
        end
      end

      def valid_resource_id?(id)
        id !~ /\d+/
      end

      def error_for_invalid_resource_id(type, id)
        error(
          status: 422,
          title: "Invalid #{type} id",
          detail: "The provided #{type} id '#{id}' should be numeric",
          source: { parameter: :id }
        )
      end

      def error_for_resource_not_found(type, id)
        error(
          status: 404,
          title: "Could not find #{type}",
          detail: "Could not find a #{type} with id #{id}",
          source: { parameter: :id }
        )
      end
    end

    resource :games do
      helpers do
        def repository
          Persistence::ROM.game_repository
        end
      end

      get do
        GameSummaryRepresenter.as_document(repository.all, request)
      end

      post do
        game = repository.create
        header 'Location', "#{request.base_url}/games/#{game.id}"
        GameRepresenter.as_document(game, request)
      end

      route_param :id do
        get do
          game = find_resource('game', params[:id])
          GameRepresenter.as_document(game, request) if game
        end
      end
    end
  end
end
