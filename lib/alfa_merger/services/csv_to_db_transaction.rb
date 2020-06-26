# frozen_string_literal: true


module AlfaMerger
  module Services
    class CsvToDbTransaction
      # @param [AlfaMerger::Models::CsvTransaction] csv_record
      def call(csv_record)
        db_record = Models::DbTransaction.new
        db_record.account_name = csv_record.account_name

        set_right_account(db_record, csv_record)

        db_record.currency_code = csv_record.currency
        db_record.date = DateTime.strptime(csv_record.date, "%d.%m.%y")
        db_record.ref = csv_record.ref
        db_record.description = csv_record.description
        db_record.amount_income = csv_record.amount_income
        db_record.amount_outcome = csv_record.amount_outcome
        db_record
      end

      private

      def set_right_account(db_record, csv_record)
        if csv_record.income?
          db_record.account_number_income = csv_record.account_number
        else
          db_record.account_number_outcome = csv_record.account_number
        end
      end
    end
  end
end