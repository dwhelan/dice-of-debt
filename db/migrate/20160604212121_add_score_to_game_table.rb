ROM::SQL.migration do
  change do
    alter_table :games do
      add_column :score, Integer, default: 0
    end
  end
end
