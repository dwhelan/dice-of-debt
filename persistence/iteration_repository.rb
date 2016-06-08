module DiceOfDebt
  class IterationRepository < Repository
    relations :iterations

    def create(iteration)
      attributes = iteration.attributes.reject { |k, _| k == :id }.merge(game_id: iteration.game.id)
      iteration.id = command(:create, :iterations).call(attributes).first[:id]
      iteration
    end

    def for_game(game)
      result = iterations.where(game_id: game.id).as(Iteration).to_a
      result.each { |iteration| iteration.game = game }
      result
    end
  end
end
