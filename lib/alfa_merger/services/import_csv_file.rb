# frozen_string_literal: true

module AlfaMerger
  module Services
    # ПО фану напишу не на функциональном стиле, а на изменении стейта
    # Вообще ломает мозг, другой подход - писать проще, не надо таскать агрументы, но нет защиты от невереного вызова
    # Вывод - писать на стейтах класса оч плохо - выховешь не в том состоянии - получишь неверный результат (ЧТД)
    # Аргументы метода слишком точно определяют "зависимости"
    # Блин, отличный файл вышел что бы показывать антипаттерны
    class ImportCsvFile
      def initialize(file, write_history: true, before_import: proc {}, after_row_import: proc {})
        @file = file
        @write_history = write_history
        @before_import = before_import
        @after_row_import = after_row_import
      end

      def call
        @result = ImportFileResult.new
        @result.results = []
        @result.counts = {
          created: 0,
          skipped: 0,
          error: 0,
          updated: 0,
          filtered: 0
        }

        @result.operation = Models::ImportOperation.new

        @result.operation.started_at = DateTime.now
        @result.operation.file_name = @file
        @result.operation.state = :created

        @result.operation.save if write_history?

        @csv_table = get_csv_table

        before_import_callback

        @csv_table.each do |csv_row|
          csv_record = Models::CsvTransaction.new(*csv_row[0..7])
          filter_result = Services::CsvRowFilter.new.call(csv_record)
          if filter_result
            row_import_result = filter_result
          else
            csv_record_clean = Services::CsvRowNormalize.new.call(csv_record)
            row_import_result = Services::ImportCsvRecord.new.call(csv_record_clean)
          end
          @result.results << row_import_result
          after_row_import_callback(row_import_result)
        end
        after_import_callback
        @result
      rescue StandardError => e
        crashed_import_callback(e)
        raise e
        @result
      ensure
        @result.operation.save if write_history?
      end

      def update_counts_from_result(result)
        @result.counts[result.action] += 1
      end

      def write_history?
        @write_history
      end

      def before_import_callback
        # АХАХА НИКАКОЙ СТУКТУРЫ, ГЛОБАЛЬНЫЙ СТЕЙТ, МОДИФИЦИРУЙ ГДЕ ХОЧЕШЬ
        @result.operation.rows_count = @csv_table.count
        @before_import.call(@result) if @before_import.respond_to?(:call)
      end

      def after_row_import_callback(row_import_result)
        update_counts_from_result(row_import_result)
        @after_row_import.call(@result) if @after_row_import.respond_to?(:call)
      end

      def after_import_callback
        @result.operation.ended_at = DateTime.now
        update_operation_counts
        @result.operation.state = :finished
      end

      def update_operation_counts
        @result.operation.count_created
        @result.operation.count_skipped
        @result.operation.count_error
        @result.operation.count_updated
        @result.operation.count_filtered
      end

      def crashed_import_callback(e)
        @result.operation.ended_at = DateTime.now
        @result.operation.error = e.to_s
        @result.operation.state = :crashed
      end

      def get_csv_table
        csv_table = CSV.parse(File.read(@file), col_sep: ';')
        csv_table.shift
        csv_table
      end
    end
  end
end