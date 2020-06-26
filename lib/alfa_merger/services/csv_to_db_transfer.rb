# frozen_string_literal: true


module AlfaMerger
  module Services
    class CsvToDbTransfer
      # @param [AlfaMerger::Models::CsvTransaction] csv_record
      # @param [AlfaMerger::Models::DbTransaction] db_record
      def call(csv_record, db_record)

        validate(csv_record, db_record)

        if db_record.income? && csv_record.outcome?
          db_record.account_number_outcome = csv_record.account_number
          db_record.amount_outcome = csv_record.amount_outcome
        else
          db_record.account_number_income = csv_record.account_number
          db_record.amount_income = csv_record.amount_income
        end

        db_record
      end

      def validate(csv_record, db_record)
        if csv_record.amount_income != db_record.amount_outcome
          raise BadTransferRecordError, 'Bad amount'
        end
        if csv_record.amount_outcome != db_record.amount_income
          # TODO: убрать/пофиксить если валюты разные (и видимо поменять схему на валюты =) )
          raise BadTransferRecordError, 'Bad amount'
        end
        raise BadTransferRecordError, 'Bad desc' if csv_record.description != db_record.description
        if csv_record.income? == db_record.income?

          raise BadTransferRecordError, 'Bad type'
        end
      end

    end
  end
end