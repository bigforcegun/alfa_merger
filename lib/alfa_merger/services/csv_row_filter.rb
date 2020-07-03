# frozen_string_literal: true

module AlfaMerger
  module Services
    class CsvRowFilter
      CREDIT_DESCS = [
        'Погашение ОД',
        'Предоставление транша',
        'Погашение процентов'
      ].freeze

      # @param [AlfaMerger::Models::CsvTransaction] csv_record
      # @return [Boolean]
      def call(csv_record)
        if check_credit_desk(csv_record)
          return ImportRowResult.new(:filtered, 'Internal credit transaction', csv_record, nil)
        end

        false
      end

      private

      # пропускаем внутренние банковские тразакции
      def check_credit_desk(csv_record)
        CREDIT_DESCS.any? do |desc|
          csv_record.description.include?(desc)
        end
      end
    end
  end
end
