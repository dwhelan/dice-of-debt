require './domain'

r = DiceOfDebt::Persistence.game_repository
g = r.create
p = DiceOfDebt::GamePlayer.new(g)
p.roll
