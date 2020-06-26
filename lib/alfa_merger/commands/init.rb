# frozen_string_literal: true

require_relative '../command'

module AlfaMerger
  module Commands
    class Init < AlfaMerger::Command
      def initialize(force, options)
        @force = force
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        DataBase.init
        # Command logic goes here ...
        #
        #environment = XDG::Environment.new
        #data = XDG::Data.new
        #output.puts environment.data_home
        #output.puts "OK"
        DataBase.run_migrations
      end
    end
  end
end
