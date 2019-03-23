class Item
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    raise InvalidPrice unless price.is_a?(Float) && price > 0
    @code = code
    @name = name
    @price = price
  end
end
