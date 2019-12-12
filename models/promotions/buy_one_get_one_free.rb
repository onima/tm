# frozen_string_literal: true

module Promotions
  class BuyOneGetOneFree
    FRUIT_TEA_CODE = 'FR1'

    def discount(checkout)
      multiple_fruit_tea =
        checkout.items.group_by(&:code).values.keep_if { |gi| multiple_fruit_tea?(gi) }.flatten

      return 0 if multiple_fruit_tea.empty?

      price = multiple_fruit_tea.first.price.fractional
      (multiple_fruit_tea.size / 2) * price
    end

    private

    def multiple_fruit_tea?(group_item)
      group_item.map(&:code).include?(FRUIT_TEA_CODE)
    end
  end
end
