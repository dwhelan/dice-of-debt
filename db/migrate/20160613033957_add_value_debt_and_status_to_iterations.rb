ROM::SQL.migration do
  change do
    alter_table :iterations do
      add_column :value,  Integer, default: 0
      add_column :debt,   Integer, default: 0
      add_column :status, String,  default: 'started'
    end
  end
end
