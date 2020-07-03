# frozen_string_literal: true

require_relative '../command'

module AlfaMerger
  module Commands
    class WriteConfig < AlfaMerger::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        Config.make_backup
        Config.config.write(force: true)
      end
    end
  end
end
