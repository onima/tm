# frozen_string_literal: true

require_relative 'models/item'
require_relative 'models/checkout'
require_relative 'models/promotions/over_sixty_promotion'
require_relative 'models/promotions/multiple_cheap_chairs_promotion'

item1 = Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(925, 'GBP'))
item2 = Item.new(code: '002', name: 'Little Table', price: Money.new(4500, 'GBP'))
item3 = Item.new(code: '003', name: 'Funky Light', price: Money.new(1995, 'GBP'))

checkout1 = Checkout.new([OverSixtyPromotion.new, MultipleCheapChairsPromotion.new])
checkout1.scan(item1)
checkout1.scan(item2)
checkout1.scan(item3)

checkout2 = Checkout.new([OverSixtyPromotion.new, MultipleCheapChairsPromotion.new])
checkout2.scan(item1)
checkout2.scan(item3)
checkout2.scan(item1)

checkout3 = Checkout.new([OverSixtyPromotion.new, MultipleCheapChairsPromotion.new])
checkout3.scan(item1)
checkout3.scan(item2)
checkout3.scan(item1)
checkout3.scan(item3)

puts('Test data')
puts('----------')

puts("Basket: #{checkout1.items.map(&:code).join(', ')}")
puts("Total price expected: #{checkout1.total.format}")

puts

puts("Basket: #{checkout2.items.map(&:code).join(', ')}")
puts("Total price expected: #{checkout2.total.format}")

puts

puts("Basket: #{checkout3.items.map(&:code).join(', ')}")
puts("Total price expected: #{checkout3.total.format}")

puts
