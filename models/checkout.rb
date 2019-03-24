# frozen_string_literal: true

class Checkout
  attr_reader :currency, :items, :promotional_rules

  def initialize(promotional_rules = [], currency = 'GBP')
    @items = []
    @promotional_rules = promotional_rules
    @currency = currency
  end

  def scan(item)
    @items << item
  end

  def total
    return Money.new(total_without_promotions, currency) if @promotional_rules.empty?

    Money.new(total_price_with_promotions, currency)
  end

  def total_without_promotions
    return 0 unless items?
    raise MismatchingCurrency if mismatching_currency?

    @items.map(&:price).reduce(&:+).cents
  end

  private

  def items?
    !@items.map(&:price).reduce(&:+).nil?
  end

  def mismatching_currency?
    @items.map(&:price).reduce(&:+).currency.iso_code != currency
  end

  def total_price_with_promotions
    total_without_promotions - @promotional_rules.map { |pr| pr.discount(self) }.reduce(&:+)
  end
end
