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
        DataBase.fuck

        @files.each do |file|
          results = []
          counts = {
            created: 0,
            skipped: 0,
            error: 0,
            updated: 0
          }

          output.puts "Starting parse file #{file}"
          output.puts "==================================="

          csv_table = CSV.parse(File.read(file), col_sep: ';')

          bar = TTY::ProgressBar.new(
            'processing  [✔️:created |🔗:updated |❗:errors |❓:skipped] [:bar] :elapsed :percent',
            output: output,
            total: csv_table.count
          )

          csv_table.shift
          csv_table.each do |csv_row|
            csv_record = Models::CsvTransaction.new(*csv_row[0..7])
            csv_record.normalize!
            result = Services::ImportCsvRecord.new.call(csv_record)
            results << result
            # ui update
            update_counts_from_result(counts, result)
            bar.advance(1, **count_tokens(counts))
          end

          output.puts "\n\n\n"
          output.puts results_table(results).render(:unicode)
        end
      end

      private

      def count_tokens(counts)
        { updated: counts[:updated].to_s, created: counts[:created].to_s, skipped: counts[:skipped].to_s, errors: counts[:error].to_s }
      end

      def update_counts_from_result(counts, result)
        counts[result.action] += 1
      end

      def results_table(results)
        table = TTY::Table.new header: %w[result message ref]
        results.select do |result|
          next unless result.action == :error

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
