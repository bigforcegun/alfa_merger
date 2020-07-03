# frozen_string_literal: true

module AlfaMerger
  class DataBase
    class << self

      MIGRATIONS_PATH = 'db/migrations'

      def init
        Sequel.extension :migration
        Sequel::Model.plugin :validation_helpers
        Sequel::Model.plugin :timestamps

        db
      end

      # TODO: db config
      def db
        @db ||= Sequel.connect('sqlite://tmp/alfa_merger.db')
      end

      def check
        Sequel::Migrator.check_current(self.db, MIGRATIONS_PATH)
      end

      def run_migrations
        Sequel::Migrator.run(db, "db/migrations")
      end

      def db_lazy_load_models
        require 'alfa_merger/models/db_transaction'
        require 'alfa_merger/models/import_operation'
      end

      def check_migrations_and_exit
        check_migrations

        Sequel::Migrator::Error
      end

      def create_database
        sequel.bla_bla
        migrate
        qwe do |qwe|
        end
      end

      def sql_example
        # connect to an in-memory database


        # create an items table
        DB.create_table :items do
          primary_key :id
          String :name, unique: true, null: false
          Float :price, null: false
        end

# create a dataset from the items table
        items = DB[:items]

# populate the table
        items.insert(name: 'abc', price: rand * 100)
        items.insert(name: 'def', price: rand * 100)
        items.insert(name: 'ghi', price: rand * 100)

# print out the number of records
        puts "Item count: #{items.count}"

# print out the average price
        puts "The average price is: #{items.avg(:price)}"
        output.puts "OK"
      end

    end
  end
end



