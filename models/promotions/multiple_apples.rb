# frozen_string_literal: true

module Promotions
  class MultipleApples
    PRICE_WITH_PROMOTION = 450
    APPLE_CODE = 'AP1'

    def discount(checkout)
      multiple_apples =
        checkout.items.group_by(&:code).values.keep_if { |gi| multiple_apples?(gi) }.flatten

      return 0 if multiple_apples.empty?

      multiple_apples.map { |i| i.price.cents - PRICE_WITH_PROMOTION }.reduce(:+)
    end

    private

    def multiple_apples?(group_item)
      group_item.map(&:code).include?(APPLE_CODE) && group_item.size >= 3
    end
  end
end
