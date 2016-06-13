module DiceOfDebt
  class IterationRepository < Repository
    relations :iterations, :games

    def create(iteration)
      attributes = { value: iteration.value, debt: iteration.debt, status: iteration.status.to_s, game_id: iteration.game.id }
      iteration.id = command(:create, :iterations).call(attributes).first[:id]
      iteration
    end

    def by_id(id)
      iterations.by_id(id).as(Iteration).one
    end

    def by_game(game)
      iterations.by_game_id(game.id).as(Iteration).to_a.tap do |game_iterations|
        game_iterations.each { |iteration| iteration.game = game }
      end
    end
  end
end
