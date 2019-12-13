# frozen_string_literal: true

require_relative '../../app/models/item'

class TotalCheckoutCalculator
  class << self
    attr_reader :checkout

    def call(checkout:)
      @checkout = checkout

      if checkout.promotional_rules.empty?
        return Money.new(total_without_promotions, checkout.currency)
      end

      Money.new(total_price_with_promotions, checkout.currency)
    end

    private

    def total_without_promotions
      return 0 unless items?
      raise MismatchingCurrency if mismatching_currency?

      total_price.cents
    end

    def items?
      !checkout.items.empty?
    end

    def mismatching_currency?
      total_price.currency.iso_code != checkout.currency
    end

    def total_price
      checkout.items.map(&:price).reduce(&:+)
    end

    def total_price_with_promotions
      total_without_promotions - discount
    end

    def discount
      checkout.promotional_rules.map { |pr| pr.discount(checkout.items) }.reduce(&:+)
    end
  end
end
