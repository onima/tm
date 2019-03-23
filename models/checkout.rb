class Checkout
  attr_accessor :items, :promotional_rules

  def initialize(promotional_rules = [])
    @items = []
    @promotional_rules = promotional_rules
  end

  def scan(item)
    @items << item
  end

  def total
    return total_without_promotions if @promotional_rules.empty?
    total_without_promotions - @promotional_rules.map { |pr| pr.discount(self) }.reduce(&:+)
  end

  def total_without_promotions
    @items.map(&:price).reduce(&:+) || 0
  end
end
