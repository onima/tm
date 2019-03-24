# frozen_string_literal: true

require_relative '../../models/item'
require_relative '../../errors'

describe Item do
  describe '#initialize' do
    context 'price' do
      context 'when price is not a Money type' do
        it 'raises an InvalidPrice error' do
          expect do
            Item.new(code: '001', name: 'Very Cheap Chair', price: 9)
          end.to raise_error(InvalidPrice)
        end
      end

      context 'when price is inferior or equal to 0' do
        it 'raises an InvalidPrice error' do
          expect do
            Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(0, 'GBP'))
          end.to raise_error(InvalidPrice)
        end
      end

      context 'when price is a money type and superior to 0' do
        it 'creates a new item object' do
          expect(
            Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(950, 'GBP')).class
          ).to eq(Item)
        end
      end
    end
  end
end
