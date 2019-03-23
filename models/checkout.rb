class Checkout
  attr_accessor :items

  def initialize
    @items = []
  end

  def scan(item)
    @items << item
  end

  def total
    @items.map(&:price).reduce(&:+) || 0
  end
end
