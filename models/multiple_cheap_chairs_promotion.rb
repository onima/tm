class MultipleCheapChairsPromotion

  PRICE_WITH_PROMOTION = 8.50
  VERY_CHEAP_CHAIR_CODE = '001'.freeze

  def discount(checkout)
    multiple_cheap_chairs_for_discount =
      checkout.items.group_by(&:code).values.keep_if { |gi| gi.map(&:code).include?(VERY_CHEAP_CHAIR_CODE) && gi.size >= 2 }

    return 0 if multiple_cheap_chairs_for_discount.empty?
    multiple_cheap_chairs_for_discount.flatten.map { |i| i.price - PRICE_WITH_PROMOTION }.reduce(:+)
  end
end
