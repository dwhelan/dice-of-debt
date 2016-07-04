ROM::SQL.migration do
  change do
    alter_table :rolls do
      add_column :rolls, String
    end
  end
end
