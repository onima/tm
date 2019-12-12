# frozen_string_literal: true

require_relative 'app/models/item'
require_relative 'app/models/checkout'
require_relative 'app/models/promotions/buy_one_get_one_free'
require_relative 'app/models/promotions/apples'

item1 = Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(311, 'USD'))
item2 = Item.new(code: 'AP1', name: 'Apple', price: Money.new(500, 'USD'))
item3 = Item.new(code: 'CF1', name: 'Coffee', price: Money.new(1123, 'USD'))

checkout1 = Checkout.new([Promotions::Apples.new])
checkout1.scan(item1)
checkout1.scan(item2)
checkout1.scan(item1)
checkout1.scan(item3)

checkout2 = Checkout.new([Promotions::BuyOneGetOneFree.new, Promotions::Apples.new])
checkout2.scan(item1)
checkout2.scan(item1)

checkout3 = Checkout.new([Promotions::Apples.new, Promotions::BuyOneGetOneFree.new])
checkout3.scan(item2)
checkout3.scan(item2)
checkout3.scan(item1)
checkout3.scan(item2)

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
