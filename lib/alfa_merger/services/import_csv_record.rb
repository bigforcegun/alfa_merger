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
        if csv_record.transfer?
          transfer_record = get_and_check_transfer!(csv_record)

          if transfer_record.nil?
            db_record = CsvToDbTransaction.new.call(csv_record)
            action = :created
            message = 'New transaction created'
          else
            db_record = CsvToDbTransfer.new.call(csv_record, transfer_record)
            action = :updated
            message = 'New transfer linked'
          end
        else
          check_sha_dups!(csv_record)
          db_record = CsvToDbTransaction.new.call(csv_record)
          action = :created
          message = 'New transaction created'
        end

        db_record.save
        ImportRowResult.new(action, message, csv_record, db_record)
      rescue TransactionDupError => e
        # binding.pry
        ImportRowResult.new(:skipped, e.message, csv_record, nil, e)
      rescue ImportDupError => e
        ImportRowResult.new(:skipped, e.message, csv_record, nil, e)
      rescue StandardError => e
        ImportRowResult.new(:error, e.message, csv_record, nil, e)
      end

      private

      def check_sha_dups!(csv_record)
        # убейте меня
        raise TransactionDupError, 'Duplicate transaction record' unless Models::DbTransaction.where(
          sha_ref: csv_record.sha_ref
        ).first.nil?
      end

      def get_and_check_transfer!(csv_record)
        transfer_record = Models::DbTransaction.first(
          ref: csv_record.ref
          # date: csv_record.date
        )
        raise ImportDupError, 'Completed transfer record' if !transfer_record.nil? && transfer_record.completed?
        raise ImportDupError, 'Existing initial transfer record' if transfer_record&.sha_ref == csv_record.sha_ref

        transfer_record
      end
    end
  end
end
