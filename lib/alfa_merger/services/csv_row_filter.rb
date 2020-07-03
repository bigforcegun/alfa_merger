# frozen_string_literal: true

module AlfaMerger
  module Services
    class CsvRowFilter

      # @param [AlfaMerger::Models::CsvTransaction] csv_record
      # @return [Boolean]
      def call(csv_record)
        if check_credit_desk(csv_record)
          return ImportRowResult.new(:filtered, 'Internal credit transaction', csv_record, nil)
        end

        nil
      end

      private

      # пропускаем внутренние банковские тразакции
      def check_credit_desk(csv_record)
        Config.config.fetch(:filter_descriptions).any? do |desc|
          csv_record.description.include?(desc)
        end
      end
    end
  end
end
