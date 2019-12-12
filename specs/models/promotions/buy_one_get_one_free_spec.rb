# frozen_string_literal: true

require_relative '../../../app/models/promotions/buy_one_get_one_free'
require_relative '../../../app/models/checkout'
require_relative '../../../app/models/item'

describe Promotions::BuyOneGetOneFree do
  subject(:buy_one_get_one_free_promotion) { Promotions::BuyOneGetOneFree.new }

  let(:checkout) { Checkout.new }
  let(:apple_item) do
    Item.new(code: 'AP1', name: 'Apple', price: Money.new(500, 'USD'))
  end
  let(:fruit_tea_item) do
    Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(311, 'USD'))
  end

  describe '.discount' do
    context 'when there are no fruit tea in items' do
      it 'returns 0 as discount' do
        2.times { checkout.scan(apple_item) }

        expect(subject.discount(checkout)).to eq(0)
      end
    end

    context 'when there are two fruit tea in items' do
      it 'returns price of one item as discount' do
        2.times { checkout.scan(fruit_tea_item) }

        expect(subject.discount(checkout)).to eq(fruit_tea_item.price.fractional)
      end
    end

    context 'when there are three fruit tea in items' do
      it 'returns price of one item as discount' do
        3.times { checkout.scan(fruit_tea_item) }

        expect(subject.discount(checkout)).to eq(fruit_tea_item.price.fractional)
      end
    end

    context 'when there are four fruit tea in items' do
      it 'returns price of two items as discount' do
        4.times { checkout.scan(fruit_tea_item) }

        expect(subject.discount(checkout)).to eq(fruit_tea_item.price.fractional * 2)
      end
    end
  end
end
