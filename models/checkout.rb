class Checkout
  attr_accessor :items, :promotional_rules
  attr_reader :currency

  def initialize(promotional_rules = [], currency = "GBP")
    @items = []
    @promotional_rules = promotional_rules
    @currency = currency
  end

  def scan(item)
    @items << item
  end

  def total
    return Money.new(total_without_promotions, currency) if @promotional_rules.empty?
    final_price = total_without_promotions - @promotional_rules.map { |pr| pr.discount(self) }.reduce(&:+)
    Money.new(final_price, currency)
  end

  def total_without_promotions
    return 0 unless items?
    raise MismatchingCurrency if @items.map(&:price).reduce(&:+).currency.iso_code != currency
    @items.map(&:price).reduce(&:+).cents
  end

  private

  def items?
    !(@items.map(&:price).reduce(&:+)).nil?
  end
end
