# frozen_string_literal: true

require_relative '../command'

module AlfaMerger
  module Commands
    class PrintConfig < AlfaMerger::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        output.puts '======= app config ======='
        output.puts AlfaMerger::Config.config.to_h
        output.puts '======= db config ======='
        output.puts AlfaMerger::Config.db_config.to_h
        #TODO: extended db config
      end
    end
  end
end
