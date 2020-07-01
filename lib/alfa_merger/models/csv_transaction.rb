# frozen_string_literal: true

module AlfaMerger
  module Models
    CsvTransaction = Struct.new(:account_name, :account_number, :currency, :date, :ref, :description, :amount_income, :amount_outcome) do
      TRANSFER_DESC = 'Внутрибанковский перевод между счетами'

      attr_accessor :sha_ref

      # @return [Boolean]
      def income?
        amount_outcome.zero?
      end

      # @return [Boolean]
      def outcome?
        amount_income.zero?
      end

      def transfer?
        description.include?(TRANSFER_DESC)
      end
    end
  end
end
