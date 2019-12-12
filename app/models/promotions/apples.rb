# frozen_string_literal: true

require_relative '../../services/items_fetcher'

module Promotions
  class Apples
    PRICE_WITH_PROMOTION = 450
    APPLE_CODE = 'AP1'

    def discount(checkout)
      apples = ItemsFetcher.call(items: checkout.items, code: APPLE_CODE)

      apples.empty? || apples.size < 3 ? 0 : price_to_deduct(apples)
    end

    private

    def price_to_deduct(apples)
      apples.map { |i| i.price.cents - PRICE_WITH_PROMOTION }.reduce(:+)
    end
  end
end
