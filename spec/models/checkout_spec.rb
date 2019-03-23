require_relative '../../models/item'
require_relative '../../models/checkout'

describe Checkout do
  subject(:checkout) { Checkout.new }
  let(:item_1) { Item.new(code: '001', name: 'Very Cheap Chair', price: 10.00) }
  let(:item_2) { Item.new(code: '002', name: 'Little Table', price: 40.00) }

  describe '#scan' do
    it 'adds an item to checkout' do
      subject.scan(item_1)
      expect(subject.items).to include(item_1)
    end
  end

  describe '#total' do
    context 'with multiple items in checkout' do
      it 'calculates the total price of the scanned items' do
        checkout.items = [item_1, item_2]
        expect(checkout.total).to eq(50)
      end
    end

    context 'with no items in checkout' do
      it 'returns 0' do
        expect(checkout.total).to eq(0)
      end
    end
  end
end
