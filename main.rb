require_relative 'models/item'
require_relative 'models/checkout'
require_relative 'models/over_sixty_promotion'
require_relative 'models/multiple_cheap_chairs_promotion'

item_1 = Item.new(code: '001', name: 'Very Cheap Chair', price: 9.25)
item_2 = Item.new(code: '002', name: 'Little Table', price: 45.00)
item_3 = Item.new(code: '003', name: 'Funky Light', price: 19.95)

checkout_1 = Checkout.new([OverSixtyPromotion.new, MultipleCheapChairsPromotion.new])
checkout_1.scan(item_1)
checkout_1.scan(item_2)
checkout_1.scan(item_3)

checkout_2 = Checkout.new([OverSixtyPromotion.new, MultipleCheapChairsPromotion.new])
checkout_2.scan(item_1)
checkout_2.scan(item_3)
checkout_2.scan(item_1)

checkout_3 = Checkout.new([OverSixtyPromotion.new, MultipleCheapChairsPromotion.new])
checkout_3.scan(item_1)
checkout_3.scan(item_2)
checkout_3.scan(item_1)
checkout_3.scan(item_3)

puts("Test data")
puts("----------")

puts("Basket: #{checkout_1.items.map(&:code).join(', ')}")
puts("Total price expected: #{checkout_1.total}")

puts

puts("Basket: #{checkout_2.items.map(&:code).join(', ')}")
puts("Total price expected: #{checkout_2.total}")

puts

puts("Basket: #{checkout_3.items.map(&:code).join(', ')}")
puts("Total price expected: #{checkout_3.total}")

puts
