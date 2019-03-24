# frozen_string_literal: true

class OverSixtyPromotion
  DISCOUNT_PERCENTAGE = 10
  PRICE_LIMIT_BEFORE_DISCOUNT = 6000

  def discount(checkout)
    return 0 unless checkout.total_without_promotions > PRICE_LIMIT_BEFORE_DISCOUNT

    price_to_substract(checkout.total_without_promotions)
  end

  private

  def price_to_substract(price)
    price * (DISCOUNT_PERCENTAGE * 0.01)
  end
end
