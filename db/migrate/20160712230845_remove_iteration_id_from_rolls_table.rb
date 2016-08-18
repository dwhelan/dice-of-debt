ROM::SQL.migration do
  change do
    alter_table :rolls do
      drop_foreign_key :iteration_id
    end
  end
end
