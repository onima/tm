require_relative '../../models/item'
require_relative '../../errors'

describe Item do
  describe '#initialize' do
    context 'price' do
      context 'when price is not a float' do
        it 'raises an InvalidPrice error' do
          expect do
            Item.new(code: '001', name: 'Very Cheap Chair', price: 9)
          end.to raise_error(InvalidPrice)
        end
      end

      context 'when price is inferior or equal to 0' do
        it 'raises an InvalidPrice error' do
          expect do
            Item.new(code: '001', name: 'Very Cheap Chair', price: 0)
          end.to raise_error(InvalidPrice)
        end
      end

      context 'when price is a float and superior to 0' do
        it 'creates a new item object' do
          expect(Item.new(code: '001', name: 'Very Cheap Chair', price: 9.5).class).to eq(Item)
        end
      end
    end
  end
end
