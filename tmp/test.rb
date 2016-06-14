require './domain'

r = DiceOfDebt::Persistence::ROM.game_repository
g = r.create
p = DiceOfDebt::Player.new(g)
p.roll
