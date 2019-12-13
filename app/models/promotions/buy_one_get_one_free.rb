# frozen_string_literal: true

require_relative '../../services/items_fetcher'

module Promotions
  class BuyOneGetOneFree
    FRUIT_TEA_CODE = 'FR1'

    def discount(items)
      fruit_teas = ItemsFetcher.call(items: items, code: FRUIT_TEA_CODE)

      fruit_teas.empty? ? 0 : price_to_deduct(fruit_teas)
    end

    private

    def price_to_deduct(fruit_teas)
      (fruit_teas.size / 2) * fruit_teas.first.price.fractional
    end
  end
end
