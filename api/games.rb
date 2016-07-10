module DiceOfDebt
  class API
    resource :games do
      helpers do
        def game_repository
          Persistence::ROM.game_repository
        end
      end

      post do
        game = game_repository.create
        header 'Location', "#{request.base_url}/games/#{game.id}"
        GameRepresenter.as_document(game, request)
      end

      get do
        GameSummaryRepresenter.as_document(game_repository.all, request)
      end

      get '/:id' do
        game = find_resource('game')
        GameRepresenter.as_document(game, request) if game
      end
    end

    module BaseGameRepresenter
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def self.included(base)
        base.instance_eval do
          include ResourceRepresenter

          property :type, getter: -> _ { 'game' }
          property :id,   getter: -> _ { id.to_s }

          attributes do
            property :value_dice, getter: -> _ { dice[:value].count }
            property :debt_dice,  getter: -> _ { dice[:debt].count  }
            property :score
            property :status
          end

          links do
            property :self, getter: -> _ { "#{base_url}/games/#{id}" }
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
  end
end
