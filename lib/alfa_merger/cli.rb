# frozen_string_literal: true
require 'alfa_merger'

require 'thor'

module AlfaMerger
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'alfa_merger version'
    def version
      require_relative 'version'
      puts "v#{AlfaMerger::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'write_config', 'Rewrite config on disk.'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def write_config(*)
      if options[:help]
        invoke :help, ['write_config']
      else
        require_relative 'commands/write_config'
        AlfaMerger::Commands::WriteConfig.new(options).execute
      end
    end

    desc 'print_config', 'Print current Config.'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def print_config(*)
      if options[:help]
        invoke :help, ['print_config']
      else
        require_relative 'commands/print_config'
        AlfaMerger::Commands::PrintConfig.new(options).execute
      end
    end

    desc 'import_csv FILES...', 'Import transactions from csv files'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def import_csv(*files)
      if options[:help]
        invoke :help, ['import_csv']
      else
        require_relative 'commands/import_csv'
        AlfaMerger::Commands::ImportCsv.new(files, options).execute
      end
    end

    desc 'init_db [FORCE]', 'Init database.'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def init_db(force = false)
      if options[:help]
        invoke :help, ['init_db']
      else
        require_relative 'commands/init_db'
        AlfaMerger::Commands::InitDb.new(force, options).execute
      end
    end
  end
end
