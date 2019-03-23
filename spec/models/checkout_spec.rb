require_relative '../../models/item'
require_relative '../../models/checkout'
require_relative '../../models/over_sixty_promotion'
require_relative '../../models/multiple_cheap_chairs_promotion'

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
    context 'when no applicable promotions' do
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

    context 'when only OverSixtyPromotion' do
      let(:item_1_with_high_price) do
        Item.new(code: '007', name: 'Very Expensive Chair', price: 50.00)
      end
      let(:item_2_with_high_price) do
        Item.new(code: '008', name: 'Very Expensive Table', price: 50.00)
      end
      let(:checkout_with_over_sixty_promotion) do
        Checkout.new([OverSixtyPromotion.new])
      end

      it 'returns total price minus OverSixtyPromotion' do
        checkout_with_over_sixty_promotion.items = [item_1_with_high_price, item_2_with_high_price]
        expect(checkout_with_over_sixty_promotion.total).to eq(90.00)
      end
    end

    context 'when only MultipleCheapChairsPromotion' do
      let(:very_cheap_chair_item_1) do
        Item.new(code: '001', name: 'Very Cheap Chair', price: 10.00)
      end
      let(:very_cheap_chair_item_2) do
        Item.new(code: '001', name: 'Very Cheap Chair', price: 10.00)
      end

      let(:checkout_with_multiple_cheap_chairs_promotion) do
        Checkout.new([MultipleCheapChairsPromotion.new])
      end

      it 'returns total price minus MultipleCheapChairsPromotion' do
        checkout_with_multiple_cheap_chairs_promotion.items = [very_cheap_chair_item_1, very_cheap_chair_item_2]
        expect(checkout_with_multiple_cheap_chairs_promotion.total).to eq(17.00)
      end
    end

    context 'when both OverSixtyPromotion and MultipleCheapChairsPromotion' do
      let(:item_1_with_high_price) do
        Item.new(code: '008', name: 'Very Expensive Table', price: 80.00)
      end
      let(:very_cheap_chair_item_2) do
        Item.new(code: '001', name: 'Very Cheap Chair', price: 10.00)
      end
      let(:very_cheap_chair_item_3) do
        Item.new(code: '001', name: 'Very Cheap Chair', price: 10.00)
      end

      let(:checkout_with_multiple_promotions) do
        Checkout.new([OverSixtyPromotion.new, MultipleCheapChairsPromotion.new])
      end

      it 'returns total price minus OverSixty and MultipleCheapChairs promotions' do
        checkout_with_multiple_promotions.items = [item_1_with_high_price, very_cheap_chair_item_2, very_cheap_chair_item_3]
        expect(checkout_with_multiple_promotions.total).to eq(87.00)
      end
    end
  end
end
