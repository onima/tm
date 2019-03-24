require_relative '../../models/over_sixty_promotion'
require_relative '../../models/checkout'

describe OverSixtyPromotion do
  let(:checkout) { Checkout.new }

  describe '.discount' do
    context 'when price is below 60 discount limit' do
      let(:item_1) { Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(1000, "GBP")) }
      let(:item_2) { Item.new(code: '002', name: 'Little Table', price: Money.new(2000, "GBP")) }

      it 'returns 0 as discount' do
        checkout.items = [item_1, item_2]
        expect(OverSixtyPromotion.new.discount(checkout)).to eq(0)
      end
    end

    context 'when price is above discount limit' do
      let(:item_1_with_high_price) do
        Item.new(code: '007', name: 'Very Expensive Chair', price: Money.new(5000, "GBP"))
      end
      let(:item_2_with_high_price) do
        Item.new(code: '008', name: 'Very Expensive Table', price: Money.new(5000, "GBP"))
      end

      it 'returns a discount based on price and discount percentage' do
        checkout.items = [item_1_with_high_price, item_2_with_high_price]
        expect(OverSixtyPromotion.new.discount(checkout)).to eq(1000)
      end
    end
  end
end
