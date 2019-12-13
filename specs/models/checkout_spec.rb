# frozen_string_literal: true

require_relative '../../app/models/item'
require_relative '../../app/models/checkout'
require_relative '../../app/models/promotions/buy_one_get_one_free'
require_relative '../../app/models/promotions/apples'
require_relative '../../errors'

describe Checkout do
  subject(:checkout) { Checkout.new }

  let(:apple_item) do
    Item.new(code: 'AP1', name: 'Apple', price: Money.new(500, 'USD'))
  end
  let(:fruit_tea_item) do
    Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(311, 'USD'))
  end

  describe '#scan' do
    it 'adds an item to checkout' do
      subject.scan(apple_item)

      expect(subject.items).to include(apple_item)
    end
  end

  describe '#total' do
    it 'calls TotalCheckoutCalculator service' do
      expect(TotalCheckoutCalculator).to receive(:call).with(checkout: subject)

      subject.total
    end
  end
end
