Sequel.migration do
  change do
    create_table(:import_operations) do
      primary_key :id

      column :file_name, String, size: 100, null: true

      column :rows_count, Integer, null: true

      column :count_created, Integer, null: true
      column :count_skipped, Integer, null: true
      column :count_error, Integer, null: true
      column :count_updated, Integer, null: true
      column :count_filtered, Integer, null: true

      column :state, String, size: 20, null: true
      column :error, String, text: true, null: true

      column :started_at, DateTime, null: false
      column :ended_at, DateTime, null: true
    end

    alter_table(:import_operations) do
      add_index :file_name
    end
  end
end