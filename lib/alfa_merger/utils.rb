module AlfaMerger
  class Utils
    class << self
      def to_cents(amount)
        (amount.to_d * 100).to_i
      end
    end
  end
end