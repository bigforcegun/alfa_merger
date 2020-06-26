Sequel.migration do
  change do
    create_table(:transactions) do
      primary_key :id

      column :account_name, String, null: false
      column :account_number_income, Integer, null: true
      column :account_number_outcome, Integer, null: true

      column :currency_code, String, size: 3, null: false
      column :ref, String, size: 100, null: false
      column :description, String, text: true, null: false
      column :date, Date, null: false

      column :amount_income, Integer, null: false
      column :amount_outcome, Integer, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: true
    end

    alter_table(:transactions) do
      add_index :account_name
      add_index :account_number_income
      add_index :account_number_outcome
      add_index :ref, unique: true
      add_index :created_at
    end
  end
end