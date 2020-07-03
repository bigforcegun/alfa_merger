# frozen_string_literal: true

# НЕ DRY кек
module AlfaMerger
  class Config
    APP_ID = 'alfa_merger'

    attr_reader :config
    attr_reader :instance
    attr_reader :db_config

    DbConfig = Struct.new(:dir, :name) do
      def path_backup
        "#{dir}/#{backup_name}.db"
      end

      def backup_name
        "#{name}_#{DateTime.now}"
      end

      def path
        "#{dir}/#{name}.db"
      end
    end

    def initialize
      @xdg_config = XDG::Config.new

      check_and_create_config_dir

      @config = TTY::Config.new
      @config.filename = 'config'
      @config.extname = '.yml'
      @config.append_path config_dir
      @config.append_path "/etc/#{APP_ID}" # WHY NOT
      @config.append_path Dir.pwd

      set_defailts!
      save_if_not_exists!

      @db_config = DbConfig.new(config_dir, APP_ID.to_s)
    end

    def self.make_backup
      if Pathname(config.source_file).exist?
        TTY::File.copy_file config.source_file, backup_file
      end
    end

    def config_dir
      @xdg_config.home + APP_ID
    end

    def self.backup_file
      path = File.dirname(File.absolute_path(config.source_file))
      "#{path}/#{config.filename}_#{DateTime.now}#{config.extname}"
    end

    def check_and_create_config_dir
      TTY::File.create_dir(config_dir)
    end

    def self.config
      @instance ||= new
      @instance.config
    end

    def self.db_config
      @instance ||= new
      @instance.db_config
    end

    def set_defailts!
      config.set_if_empty :filter_descriptions, value: [
        'Погашение ОД',
        'Предоставление транша',
        'Погашение процентов'
      ]
    end

    def save_if_not_exists!
      @config.write unless Pathname.new(@config.source_file).exist?
    end
  end
end
