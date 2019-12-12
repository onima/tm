# frozen_string_literal: true

require_relative '../../../app/models/promotions/apples'
require_relative '../../../app/models/checkout'
require_relative '../../../app/models/item'

describe Promotions::Apples do
  subject(:apples_promotion) { Promotions::Apples.new }

  let(:checkout) { Checkout.new }
  let(:apple_item) do
    Item.new(code: 'AP1', name: 'Apple', price: Money.new(500, 'USD'))
  end
  let(:fruit_tea_item) do
    Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(311, 'USD'))
  end

  describe '.discount' do
    context 'when there are no apples in items' do
      it 'returns 0 as discount' do
        2.times { checkout.scan(fruit_tea_item) }

        expect(subject.discount(checkout)).to eq(0)
      end
    end

    context 'when there are only two apples in items' do
      it 'returns 0 as discount' do
        2.times { checkout.scan(apple_item) }

        expect(subject.discount(checkout)).to eq(0)
      end
    end

    context 'when there are at least three apples in items' do
      it 'returns total discount for all the apples which is the sum of current price minus discount for each apple' do # rubocop:disable Metrics/LineLength
        3.times { checkout.scan(apple_item) }
        checkout.scan(fruit_tea_item)

        expect(subject.discount(checkout)).to eq(150)
      end
    end
  end
end
