# frozen_string_literal: true

require 'sequel'
require 'runcom'
require 'pry'
require 'csv'
require 'tty-color'
require 'tty-table'
require 'tty-progressbar'
require 'digest'
require 'bigdecimal'
require 'bigdecimal/util'

require 'alfa_merger/version'
require 'alfa_merger/data_base'
require 'alfa_merger/csv_parser'
require 'alfa_merger/utils'

require 'alfa_merger/services/import_csv_record'
require 'alfa_merger/services/csv_to_db_transfer'
require 'alfa_merger/services/csv_to_db_transaction'

require 'alfa_merger/models/csv_transaction'

module AlfaMerger
  class Error < StandardError; end

  class AccountDupError < Error; end

  class ImportDupError < Error; end

  class BadTransferRecordError < Error; end

  ImportResult = Struct.new(:action, :message, :csv_record, :db_record, :error)
end
