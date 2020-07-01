# frozen_string_literal: true

module AlfaMerger
  module Services
    class CsvRowNormalize
      BAD_REFS = [
        'CRD_'
      ].freeze

      def call(csv_record)
        normalized_record = csv_record.dup
        set_sha_ref!(normalized_record)
        fix_types!(normalized_record)

        normalized_record.freeze
        normalized_record
      end

      private

      # у некоторых старых транзакций пустой реф - а они нам нужны
      def fix_empty_ref!(csv_record)
        set_sha_ref!(csv_record) if csv_record.ref.nil? || csv_record.ref.empty?
        set_sha_ref!(csv_record) if BAD_REFS.include?(csv_record)
      end

      # приводим типы - привет dry-struct
      def fix_types!(csv_record)
        # csv_record.account_number = csv_record.account_number.to_i
        csv_record.account_number = csv_record.account_number.to_s
        csv_record.amount_income = Utils.to_cents(csv_record.amount_income)
        csv_record.amount_outcome = Utils.to_cents(csv_record.amount_outcome)
        csv_record.date = Date.strptime(csv_record.date, '%d.%m.%y')
      end

      def set_sha_ref!(csv_record)
        csv_record.sha_ref = Digest::SHA256.hexdigest(csv_record.to_h.to_s)
      end
    end
  end
end
