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

    desc 'import_csv FILES...', 'Command description...'
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
    
    desc 'init [FORCE]', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def init(force = false)
      if options[:help]
        invoke :help, ['init']
      else
        require_relative 'commands/init'
        AlfaMerger::Commands::Init.new(force, options).execute
      end
    end
  end
end
