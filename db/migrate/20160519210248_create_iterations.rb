ROM::SQL.migration do
  change do
    create_table :iterations do
      primary_key :id
      foreign_key :game_id, :games
    end
  end
end
