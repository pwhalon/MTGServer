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

  describe '#create_card' do
    context 'when the parameters are valid' do
      it 'creates a new card in the database' do
        expect(MyCard.where(name: 'card5')).to be_empty
        MyCard.create_card('name' => 'card5', 'quantity' => 1, 'box_number' => 1)
        expect(MyCard.where(name: 'card5').pluck(:name)).to eq(%w(card5))
      end
    end

    context 'with invalid parameters' do
      it 'returns the card without saving' do
        expect(MyCard.where(name: 'card5')).to be_empty
        test_card = MyCard.create_card('name' => 'card5', 'quantity' => 'q', 'box_number' => 1)
        expect(MyCard.where(name: 'card5')).to be_empty
        expect(test_card.errors.full_messages.to_sentence).to eq('Quantity is not a number')
      end
    end
  end

  describe '#make_transaction' do
    context 'when the quantity is valid' do
      it 'completes the transaction' do
        target_card = MyCard.where(name: 'card1')
        target_card.make_transaction({'quantity' => 2})

        expect(target_card.first.quantity).to eq(6)
      end
    end

    context 'when the quantity makes the card invalid' do
      it 'does not save the card' do
        target_card = MyCard.where(name: 'card1')
        post_transaction_card = target_card.make_transaction('quantity' => -100000000)

        expect(post_transaction_card.errors.full_messages.to_sentence).to eq('Quantity must be greater than or equal to 0')
        expect(target_card.first.quantity).to eq(4)
      end
    end

    context 'when the user entered quantity is not a number' do
      it 'does not save the card' do
        target_card = MyCard.where(name: 'card1')
        post_transaction_card = target_card.make_transaction('quantity' => 'q')

        expect(post_transaction_card.valid?).to be_falsey
        expect(post_transaction_card.errors.full_messages.to_sentence).to eq("Quantity can't be blank and Quantity is not a number")
        expect(target_card.first.quantity).to eq(4)
      end
    end
  end
end
