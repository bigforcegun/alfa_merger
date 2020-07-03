# frozen_string_literal: true

require_relative '../command'

module AlfaMerger
  module Commands
    class InitDb < AlfaMerger::Command
      def initialize(force, options)
        @force = force
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        DataBase.init
        DataBase.db.logger = Logger.new($stdout)
        if @force
          DataBase.make_backup
          DataBase.clean_migrations
        end
        DataBase.run_migrations
      end
    end
  end
end
