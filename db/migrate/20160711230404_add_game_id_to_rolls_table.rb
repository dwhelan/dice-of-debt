ROM::SQL.migration do
  change do
    alter_table :rolls do
      add_foreign_key :game_id, :games
    end
  end
end
