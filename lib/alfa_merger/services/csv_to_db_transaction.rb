# frozen_string_literal: true


module AlfaMerger
  module Services
    class CsvToDbTransaction
      # @param [AlfaMerger::Models::CsvTransaction] csv_record
      def call(csv_record)
        db_record = Models::DbTransaction.new
        # db_record.account_name = csv_record.account_name

        set_right_account(db_record, csv_record)
        set_right_currency(db_record, csv_record)

        db_record.date = csv_record.date
        db_record.ref = csv_record.ref
        db_record.sha_ref = csv_record.sha_ref
        db_record.description = csv_record.description
        db_record.amount_income = csv_record.amount_income
        db_record.amount_outcome = csv_record.amount_outcome
        db_record
      end

      private

      def set_right_currency(db_record, csv_record)
        if csv_record.income?
          db_record.currency_income = csv_record.currency
        else
          db_record.currency_outcome = csv_record.currency
        end
      end


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