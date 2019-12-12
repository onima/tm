# frozen_string_literal: true

require_relative '../../app/models/item'
require_relative '../../errors'

describe Item do
  describe '#initialize' do
    context 'price' do
      context 'when price is not a Money type' do
        it 'raises an InvalidPrice error' do
          expect do
            Item.new(code: 'FR1', name: 'Fruit tea', price: 9)
          end.to raise_error(InvalidPrice)
        end
      end

      context 'when price is inferior or equal to 0' do
        it 'raises an InvalidPrice error' do
          expect do
            Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(0, 'USD'))
          end.to raise_error(InvalidPrice)
        end
      end

      context 'when price is a money type and superior to 0' do
        it 'creates a new item object' do
          expect(
            Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(950, 'USD')).class
          ).to eq(Item)
        end
      end
    end
  end
end
