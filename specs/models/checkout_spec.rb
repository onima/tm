# frozen_string_literal: true

require_relative '../../app/models/item'
require_relative '../../app/models/checkout'
require_relative '../../app/models/promotions/buy_one_get_one_free'
require_relative '../../app/models/promotions/multiple_apples'
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
    context 'when no applicable promotions' do
      context 'with multiple items in checkout' do
        it 'calculates the total price of the scanned items' do
          subject.scan(apple_item)
          subject.scan(fruit_tea_item)

          expect(subject.total).to eq(Money.new(811, 'USD'))
        end
      end

      context 'with no items in checkout' do
        it 'returns 0' do
          expect(subject.total).to eq(Money.new(0, 'USD'))
        end
      end
    end
    context 'currency' do
      context 'when items currency mismatch checkout currency' do
        let(:fruit_tea_item_with_gbp_currency) do
          Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(311, 'GBP'))
        end
        let(:checkout_with_usd_currency) do
          Checkout.new([], 'USD')
        end

        it 'raises a MismatchingCurrency Error' do
          checkout_with_usd_currency.scan(fruit_tea_item_with_gbp_currency)

          expect { checkout_with_usd_currency.total }.to raise_error(MismatchingCurrency)
        end
      end

      context 'when items currency match checkout currency' do
        let(:fruit_tea_item_with_usd_currency) do
          Item.new(code: 'FR1', name: 'Fruit tea', price: Money.new(311, 'USD'))
        end
        let(:checkout_with_usd_currency) do
          Checkout.new([], 'USD')
        end

        it 'does not raise a MismatchingCurrency Error' do
          checkout_with_usd_currency.scan(fruit_tea_item_with_usd_currency)

          expect { checkout_with_usd_currency.total }.not_to raise_error
        end
      end
    end

    context 'when only BuyOneGetOneFreePromotion' do
      let(:checkout_with_buy_one_get_one_free_promotion) do
        Checkout.new([Promotions::BuyOneGetOneFree.new])
      end

      it 'returns total price minus BuyOneGetOneFree promotion' do
        4.times { checkout_with_buy_one_get_one_free_promotion.scan(fruit_tea_item) }

        expect(checkout_with_buy_one_get_one_free_promotion.total).to eq(Money.new(622, 'USD'))
      end
    end

    context 'when only MultipleApples promotion' do
      let(:checkout_with_multiple_apples_promotion) do
        Checkout.new([Promotions::MultipleApples.new])
      end

      it 'returns total price minus MultipleApples promotion' do
        3.times { checkout_with_multiple_apples_promotion.scan(apple_item) }

        expect(checkout_with_multiple_apples_promotion.total).to eq(Money.new(1350, 'USD'))
      end
    end

    context 'when both BuyOneGetOneFree and MultipleApples promotions' do
      let(:checkout_with_multiple_promotions) do
        Checkout.new([Promotions::BuyOneGetOneFree.new, Promotions::MultipleApples.new])
      end

      it 'returns total price minus BuyOneGetOneFree and MultipleApples promotions' do
        2.times { checkout_with_multiple_promotions.scan(fruit_tea_item) }
        3.times { checkout_with_multiple_promotions.scan(apple_item) }

        expect(checkout_with_multiple_promotions.total).to eq(Money.new(1661, 'USD'))
      end
    end
  end
end
