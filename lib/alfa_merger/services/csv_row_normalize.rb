# frozen_string_literal: true

module AlfaMerger
  module Services
    class CsvRowNormalize
      def call(csv_record)
        normalized_record = csv_record.dup
        fix_empty_ref!(normalized_record)
        fix_types!(normalized_record)
        normalized_record.freeze
        normalized_record
      end

      private

      # у некоторых старых транзакций пустой реф - а они нам нужны
      def fix_empty_ref!(csv_record)
        if csv_record.ref.nil? || csv_record.ref.empty?
          csv_record.ref = Digest::SHA256.hexdigest(csv_record.ref.to_h.to_s)
        end
      end

      # приводим типы - привет dry-struct
      def fix_types!(csv_record)
        csv_record.account_number = csv_record.account_number.to_i
        csv_record.amount_income = Utils.to_cents(csv_record.amount_income)
        csv_record.amount_outcome = Utils.to_cents(csv_record.amount_outcome)
      end
    end
  end
end




