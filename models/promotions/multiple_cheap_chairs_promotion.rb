# frozen_string_literal: true

class MultipleCheapChairsPromotion
  PRICE_WITH_PROMOTION = 850
  VERY_CHEAP_CHAIR_CODE = '001'

  def discount(checkout)
    multiple_cheap_chairs =
      checkout.items.group_by(&:code).values.keep_if { |gi| multiple_cheap_chairs?(gi) }.flatten

    return 0 if multiple_cheap_chairs.empty?

    multiple_cheap_chairs.map { |i| i.price.cents - PRICE_WITH_PROMOTION }.reduce(:+)
  end

  private

  def multiple_cheap_chairs?(group_item)
    group_item.map(&:code).include?(VERY_CHEAP_CHAIR_CODE) && group_item.size >= 2
  end
end
