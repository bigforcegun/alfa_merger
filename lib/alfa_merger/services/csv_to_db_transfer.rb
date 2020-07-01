# frozen_string_literal: true

module AlfaMerger
  module Services
    class CsvToDbTransfer
      # @param [AlfaMerger::Models::CsvTransaction] csv_record
      # @param [AlfaMerger::Models::DbTransaction] db_record
      def call(csv_record, db_record)
        validate(csv_record, db_record)

        # FUUUUUU
        if db_record.income? && csv_record.outcome?
          db_record.account_number_outcome = csv_record.account_number
          db_record.amount_outcome = csv_record.amount_outcome
          db_record.currency_outcome = csv_record.currency
        else
          db_record.account_number_income = csv_record.account_number
          db_record.amount_income = csv_record.amount_income
          db_record.currency_income = csv_record.currency
        end

        db_record
      end

      def validate(csv_record, db_record)
        if db_record.income?
          if csv_record.currency == db_record.currency_outcome
            validate_transaction_amount(csv_record, db_record)
          end
        else
          if csv_record.currency == db_record.currency_income
            validate_transaction_amount(csv_record, db_record)
          end
        end

        raise BadTransferRecordError, 'Bad desc' if csv_record.description != db_record.description
        raise BadTransferRecordError, 'Bad type' if csv_record.income? == db_record.income?
      end

      def validate_transaction_amount(csv_record, db_record)
        raise BadTransferRecordError, 'Bad amount' if csv_record.amount_income != db_record.amount_outcome
        raise BadTransferRecordError, 'Bad amount' if csv_record.amount_outcome != db_record.amount_income
      end
    end
  end
end
