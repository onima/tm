require_relative '../../models/multiple_cheap_chairs_promotion'
require_relative '../../models/checkout'

describe MultipleCheapChairsPromotion do
  let(:checkout) { Checkout.new }

  describe '.discount' do
    context 'when there are no cheap chairs in items' do
      let(:item_1) { Item.new(code: '002', name: 'Funky Light', price: 10.00) }
      let(:item_2) { Item.new(code: '003', name: 'Little Table', price: 20.00) }

      it 'returns 0 as discount' do
        checkout.items = [item_1, item_2]
        expect(MultipleCheapChairsPromotion.new.discount(checkout)).to eq(0)
      end
    end

    context 'when there is only one cheap chair in items' do
      let(:item_1) { Item.new(code: '001', name: 'Very Cheap Chair', price: 10.00) }
      let(:item_2) { Item.new(code: '003', name: 'Little Table', price: 20.00) }

      it 'returns 0 as discount' do
        checkout.items = [item_1, item_2]
        expect(MultipleCheapChairsPromotion.new.discount(checkout)).to eq(0)
      end
    end

    context 'when there are at least two cheap chair in items' do
      let(:item_1) { Item.new(code: '001', name: 'Very Cheap Chair', price: 10.00) }
      let(:item_2) { Item.new(code: '001', name: 'Very Cheap Chair', price: 10.00) }
      let(:item_3) { Item.new(code: '003', name: 'Little Table', price: 20.00) }

      it 'returns total discount for all the cheap chairs which is the sum of current price minus discount for each chair' do
        checkout.items = [item_1, item_2, item_3]
        expect(MultipleCheapChairsPromotion.new.discount(checkout)).to eq(3.00)
      end
    end
  end
end
