# frozen_string_literal: true

module AlfaMerger
  module Models
    CsvTransaction = Struct.new(:account_name, :account_number, :currency, :date, :ref, :description, :amount_income, :amount_outcome) do

      # @return [Boolean]
      def income?
        amount_outcome.zero?
      end

      # @return [Boolean]
      def outcome?
        amount_income.zero?
      end

      # так проще, хоть и неверно
      def normalize!

        freeze
      end
    end
  end
end