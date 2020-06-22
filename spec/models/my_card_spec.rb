require 'rails_helper'

RSpec.describe MyCard, type: :model do
  let!(:magic_cards) do
    (1..5).each do |iterator|
      MagicCard.create(name: "card#{iterator}")
    end
  end

  let!(:my_test_cards) do
    MyCard.create(name: 'card1', quantity: 4, box: 3)
    MyCard.create(name: 'card2', quantity: 3, box: 1)
    MyCard.create(name: 'card3', quantity: 2, box: 5)
    MyCard.create(name: 'card4', quantity: 1, box: 2)
    MyCard.create(name: 'card2', quantity: 4, box: 3)
  end

  describe '.with_box_number' do
    context 'where the box number matches some of my cards' do
      it 'should return the correct matching cards' do
        expect(MyCard.with_box_number(3)).to eq(MyCard.where(box: 3))
      end
    end

    context 'where the box number matches none of my cards' do
      it 'should return no matching cards' do
        expect(MyCard.with_box_number(6)).to be_empty
      end
    end
  end

  describe '.having_quantity' do
    context 'where the quantity matches some of my cards' do
      it 'should return the correct matching cards' do
        expect(MyCard.having_quantity(3)).to eq(MyCard.where(quantity: 3))
      end
    end

    context 'where the quantity matches none of my cards' do
      it 'should return no matching cards' do
        expect(MyCard.having_quantity(6)).to be_empty
      end
    end
  end

  describe '.with_name' do
    context 'where the name matches some of my cards' do
      it 'should return the correct matching cards' do
        expect(MyCard.with_name('card1')).to eq(MyCard.where(name: 'card1'))
      end
    end

    context 'where the name matches none of my cards' do
      it 'should return no matching cards' do
        expect(MyCard.with_name('random_card')).to be_empty
      end
    end
  end
end
