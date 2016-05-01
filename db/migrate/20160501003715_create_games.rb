ROM::SQL.migration do
  change do
    create_table :games do
      primary_key :id
    end
  end
end
