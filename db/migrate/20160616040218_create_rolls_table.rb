ROM::SQL.migration do
  change do
    create_table :rolls do
      primary_key :id
      foreign_key :iteration_id, :iterations
    end
  end
end
