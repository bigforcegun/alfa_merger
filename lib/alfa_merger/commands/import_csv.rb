# frozen_string_literal: true

require_relative '../command'

module AlfaMerger
  module Commands
    class ImportCsv < AlfaMerger::Command
      def initialize(files, options)
        @files = files
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        DataBase.init
        DataBase.check
        DataBase.db_lazy_load_models

        @files.each do |file|
          output.puts "Starting parse file #{file}"
          output.puts '==================================='

          bar = TTY::ProgressBar.new(
            'processing  [✔️:created |🔗:updated |❗:errors |❓:skipped|🛑:filtered] [:bar] :elapsed :percent',
            output: output
          )

          import = Services::ImportCsvFile
                     .new(
                       file,
                       before_import: before_import_proc(bar),
                       after_row_import: after_row_import_proc(bar)
                     )
                     .call

          output.puts "\n\n\n"
          output.puts "Import done with state: #{import.operation.state}"
          if import.operation.error
            output.puts "Import exception: #{import.operation.error}"
          else
            output.puts results_table(import.results).render(:unicode)
          end
        end
      end

      private

      def before_import_proc(bar)
        lambda { |result|
          bar.update(total: result.operation.rows_count)
        }
      end

      def after_row_import_proc(bar)
        lambda { |import_result|
          bar.advance(1, **count_tokens(import_result.counts))
        }
      end

      def count_tokens(counts)
        Hash[counts.map { |k, v| [k, v.to_s] }]
      end

      def results_table(results)
        table = TTY::Table.new header: %w[result message ref]
        results.select do |result|
          next unless %i[error].include?(result.action)

          table << [
            result.action,
            result.message,
            result.csv_record.ref
          ]
        end
        table
      end
    end
  end
end
