# frozen_string_literal: true

module AlfaMerger
  module Services
    # Основная магия
    # Берем колонку из таблицы
    # Нормализуем если все плохо (нет рефа в старых тразакциях)
    # Анализирируем текущю базу
    # Проверяем
    # - реф и аккаунт номер совпадают - скип так как дубль
    # - реф совпадает, аккаунт номер другой - пытаемся проверить трансфер
    # - если трафнсфер завершен - скип как дубль
    # - если нет - дополняем запись как трансфер
    # - если все выше скип - сохраняем как новую запись


    # TODO: спец правила для
    # > Предоставление транша
    class ImportCsvRecord
      # @param [AlfaMerger::Models::CsvTransaction] csv_record
      def call(csv_record)
        check_dups(csv_record)

        transfer_record = check_transfer(csv_record)

        if transfer_record.nil?
          db_record = CsvToDbTransaction.new.call(csv_record)
          action = :created
          message = 'New transaction created'
        else
          db_record = CsvToDbTransfer.new.call(csv_record, transfer_record)
          action = :updated
          message = 'New transfer linked'
        end
        db_record.save
        ImportResult.new(action, message, csv_record, db_record)
      rescue AccountDupError => e
        ImportResult.new(:skipped, 'Duplicate transaction on account', csv_record, nil, e)
      rescue ImportDupError => e
        ImportResult.new(:skipped, 'Completed transfer record', csv_record, nil, e)
      rescue StandardError => e
        ImportResult.new(:error, e.message, csv_record, nil, e)
      end

      private

      def check_dups(csv_record)
        # убейте меня
        account_dups = if csv_record.income?
                         Models::DbTransaction.where(
                           account_number_income: csv_record.account_number,
                           ref: csv_record.ref
                         )
                       else
                         Models::DbTransaction.where(
                           account_number_outcome: csv_record.account_number,
                           ref: csv_record.ref
                         )
                       end
        raise AccountDupError unless account_dups.empty?
      end

      def check_transfer(csv_record)
        transfer_record = Models::DbTransaction.first(
          ref: csv_record.ref
        )
        raise ImportDupError if !transfer_record.nil? && transfer_record.completed?

        transfer_record
      end
    end
  end
end
