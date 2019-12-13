# frozen_string_literal: true

require_relative '../services/total_checkout_calculator'

class Checkout
  attr_reader :currency, :items, :promotional_rules

  def initialize(promotional_rules = [], currency = 'USD')
    @items = []
    @promotional_rules = promotional_rules
    @currency = currency
  end

  def scan(item)
    items << item
  end

  def total
    TotalCheckoutCalculator.call(checkout: self)
  end
end
