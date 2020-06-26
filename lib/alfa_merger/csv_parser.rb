# frozen_string_literal: true

module AlfaMerger
  class CsvParser
    def import
      table = CSV.parse(File.read(file))
      name = options[:account_name]
      number = options[:account_number]
      new_table = []

      table.each do |csv_row|
        row = ShortRow.new(*csv_row)
        if row.date.nil? || row.date.empty?
          last_col = new_table.last
          last_col.desc = "#{last_col.desc}. #{row.desc}"
        else
          new_table << NewRow.new(name, number, row.currency, row.date_formatted, row.ref, row.desc, row.income_formatted, row.outcome_formatted)
        end
      end
      new_table
    end

    def export
      CSV.open(new_file_name, 'w', {col_sep: ';'}) do |csv|
        rows_for_file.each do |row|
          csv << row.to_row
        end
      end
    end

    def some_shit(transaction,ref)
      possible_transfer_transaction = Table.find(ref: ref)
      if possible_transfer_transaction.exists
        if possible_transfer_transaction.out?
          possible_transfer_transaction.account_number = tr.account_number
        else

        end
      end

    end
  end
end
