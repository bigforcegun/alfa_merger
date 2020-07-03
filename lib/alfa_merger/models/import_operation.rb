# frozen_string_literal: true

module AlfaMerger
  module Models
    class ImportOperation < Sequel::Model(DataBase.db[:import_operations])

    end
  end
end