# frozen_string_literal: true

module AlfaMerger
  module Models
    class DbTransaction < Sequel::Model(DataBase.db[:transactions])

      def outcome?
        amount_income.zero?
      end

      def income?
        amount_outcome.zero?
      end

      # @return [Boolean]
      def completed?
        !account_number_income.nil? &&
          !account_number_outcome.nil? &&
          !amount_income.nil? &&
          !amount_outcome.nil?
      end

      def validate
        super
        # validates_min_length 1, :num_tracks
      end
    end
  end
end