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
        if ref.nil? || ref.empty?
          self.ref = Digest::SHA256.hexdigest(ref.to_h.to_s)
        end
        self.account_number = account_number.to_i
        self.amount_income = Utils.to_cents(amount_income)
        self.amount_outcome = Utils.to_cents(amount_outcome)
        freeze
      end
    end
  end
end