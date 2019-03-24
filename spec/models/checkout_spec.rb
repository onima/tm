# frozen_string_literal: true

require_relative '../../models/item'
require_relative '../../models/checkout'
require_relative '../../models/promotions/over_sixty_promotion'
require_relative '../../models/promotions/multiple_cheap_chairs_promotion'
require_relative '../../errors'

describe Checkout do
  subject(:checkout) { Checkout.new }
  let(:item_1) { Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(1000, 'GBP')) }
  let(:item_2) { Item.new(code: '002', name: 'Little Table', price: Money.new(4000, 'GBP')) }

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
          checkout.scan(item_1)
          checkout.scan(item_2)
          expect(checkout.total).to eq(Money.new(5000, 'GBP'))
        end
      end

      context 'with no items in checkout' do
        it 'returns 0' do
          expect(checkout.total).to eq(Money.new(0, 'GBP'))
        end
      end
    end

    context 'when only OverSixtyPromotion' do
      let(:item_1_with_high_price) do
        Item.new(code: '007', name: 'Very Expensive Chair', price: Money.new(5000, 'GBP'))
      end
      let(:item_2_with_high_price) do
        Item.new(code: '008', name: 'Very Expensive Table', price: Money.new(5000, 'GBP'))
      end
      let(:checkout_with_over_sixty_promotion) do
        Checkout.new([OverSixtyPromotion.new])
      end

      it 'returns total price minus OverSixtyPromotion' do
        checkout_with_over_sixty_promotion.scan(item_1_with_high_price)
        checkout_with_over_sixty_promotion.scan(item_2_with_high_price)
        expect(checkout_with_over_sixty_promotion.total).to eq(Money.new(9000, 'GBP'))
      end
    end

    context 'when only MultipleCheapChairsPromotion' do
      let(:very_cheap_chair_item_1) do
        Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(1000, 'GBP'))
      end
      let(:very_cheap_chair_item_2) do
        Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(1000, 'GBP'))
      end

      let(:checkout_with_multiple_cheap_chairs_promotion) do
        Checkout.new([MultipleCheapChairsPromotion.new])
      end

      it 'returns total price minus MultipleCheapChairsPromotion' do
        checkout_with_multiple_cheap_chairs_promotion.scan(very_cheap_chair_item_1)
        checkout_with_multiple_cheap_chairs_promotion.scan(very_cheap_chair_item_2)
        expect(checkout_with_multiple_cheap_chairs_promotion.total).to eq(Money.new(1700, 'GBP'))
      end
    end

    context 'when both OverSixtyPromotion and MultipleCheapChairsPromotion' do
      let(:item_1_with_high_price) do
        Item.new(code: '008', name: 'Very Expensive Table', price: Money.new(8000, 'GBP'))
      end
      let(:very_cheap_chair_item_2) do
        Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(1000, 'GBP'))
      end
      let(:very_cheap_chair_item_3) do
        Item.new(code: '001', name: 'Very Cheap Chair', price: Money.new(1000, 'GBP'))
      end

      let(:checkout_with_multiple_promotions) do
        Checkout.new([OverSixtyPromotion.new, MultipleCheapChairsPromotion.new])
      end

      it 'returns total price minus OverSixty and MultipleCheapChairs promotions' do
        checkout_with_multiple_promotions.scan(item_1_with_high_price)
        checkout_with_multiple_promotions.scan(very_cheap_chair_item_2)
        checkout_with_multiple_promotions.scan(very_cheap_chair_item_3)
        expect(checkout_with_multiple_promotions.total).to eq(Money.new(8700, 'GBP'))
      end
    end
  end

  describe '#total_without_promotions' do
    context 'when there are no items' do
      it 'returns 0' do
        expect(subject.total_without_promotions).to eq(0)
      end
    end

    context 'when there is at least 1 item' do
      it 'returns fractional price of the item' do
        subject.scan(item_1)
        expect(subject.total_without_promotions).to eq(1000)
      end
    end

    context 'currency' do
      context 'when items currency mismatch checkout currency' do
        let(:item_1_with_gbp_currency) do
          Item.new(code: '008', name: 'Very Expensive Table', price: Money.new(8000, 'GBP'))
        end
        let(:checkout_with_usd_currency) do
          Checkout.new([], 'USD')
        end

        it 'raises an MismatchingCurrency Error' do
          checkout_with_usd_currency.scan(item_1_with_gbp_currency)
          expect do
            checkout_with_usd_currency.total_without_promotions
          end.to raise_error(MismatchingCurrency)
        end
      end

      context 'when items currency match checkout currency' do
        let(:item_1_with_usd_currency) do
          Item.new(code: '008', name: 'Very Expensive Table', price: Money.new(8000, 'USD'))
        end
        let(:checkout_with_usd_currency) do
          Checkout.new([], 'USD')
        end

        it 'raises an MismatchingCurrency Error' do
          checkout_with_usd_currency.scan(item_1_with_usd_currency)
          expect do
            checkout_with_usd_currency.total_without_promotions
          end.not_to raise_error(MismatchingCurrency)
        end
      end
    end
  end
end
