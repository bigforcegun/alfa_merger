# frozen_string_literal: true


# Почему гемы гадят так жестко?
Warning[:deprecated] = false #FUUUU

require 'pry'
require 'csv'
require 'logger'

require 'sequel'
require 'tty-color'
require 'tty-table'
require 'tty-file'
require 'tty-config'
require 'xdg'
require 'tty-progressbar'
require 'digest'
require 'bigdecimal'
require 'bigdecimal/util'

require 'alfa_merger/version'
require 'alfa_merger/config'
require 'alfa_merger/data_base'
require 'alfa_merger/csv_parser'
require 'alfa_merger/utils'

require 'alfa_merger/services/csv_row_filter'
require 'alfa_merger/services/csv_row_normalize'
require 'alfa_merger/services/import_csv_record'
require 'alfa_merger/services/import_csv_file'
require 'alfa_merger/services/csv_to_db_transfer'
require 'alfa_merger/services/csv_to_db_transaction'

require 'alfa_merger/models/csv_transaction'

module AlfaMerger
  class Error < StandardError; end

  class TransactionDupError < Error; end

  class ImportDupError < Error; end

  class BadTransferRecordError < Error; end

  ImportRowResult = Struct.new(:action, :message, :csv_record, :db_record, :error)
  ImportFileResult = Struct.new(:operation, :counts, :results)
end
