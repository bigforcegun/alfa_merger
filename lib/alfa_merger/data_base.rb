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

      def db
        @db ||= Sequel.connect("sqlite://#{Config.db_config.path}")
      end

      def make_backup
        if Pathname(Config.db_config.path).exist?
          TTY::File.copy_file Config.db_config.path, Config.db_config.path_backup
        end
      end

      def check
        Sequel::Migrator.check_current(db, MIGRATIONS_PATH)
      end

      def run_migrations
        Sequel::Migrator.run(db, MIGRATIONS_PATH)
      end

      def clean_migrations
        Sequel::Migrator.run(db, MIGRATIONS_PATH, target: 0)
      end

      # я хз, для моделей нужны готовые таблички, так что пока так
      def db_lazy_load_models
        require 'alfa_merger/models/db_transaction'
        require 'alfa_merger/models/import_operation'
      end

      def check_migrations_and_exit
        check_migrations

        Sequel::Migrator::Error
      end
    end
  end
end
