# frozen_string_literal: true

require_relative '../../app/services/items_fetcher'
require_relative '../../app/models/checkout'
require_relative '../../app/models/item'
# require_relative '../../models/promotions/multiple_apples'

describe ItemsFetcher do
  describe '.call' do
    subject { ItemsFetcher }
    let(:fruit_tea_item) do
      Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(311, 'USD'))
    end

    context 'with a list of items' do
      context 'when provided code match items' do
        let(:apple_code) { 'AP1' }
        let(:apple_item) { Item.new(code: 'AP1', name: 'Apple', price: Money.new(500, 'USD')) }

        it 'returns items which match provided code' do
          checkout = Checkout.new
          3.times { checkout.scan(apple_item) }
          2.times { checkout.scan(fruit_tea_item) }

          expect(subject.call(items: checkout.items, code: apple_code))
            .to contain_exactly(apple_item, apple_item, apple_item)
        end
      end

      context "when provided code doesn't match any items" do
        let(:apple_code) { 'AP1' }

        it 'returns empty array' do
          checkout = Checkout.new
          2.times { checkout.scan(fruit_tea_item) }

          expect(subject.call(items: checkout.items, code: apple_code)).to eq([])
        end
      end
    end
  end
end
