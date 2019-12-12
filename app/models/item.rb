# frozen_string_literal: true

require 'money'
Money.locale_backend = nil
Money.rounding_mode = BigDecimal::ROUND_HALF_UP

class Item
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    raise InvalidPrice unless price.is_a?(Money) && price.cents.positive?

    @code = code
    @name = name
    @price = price
  end
end
