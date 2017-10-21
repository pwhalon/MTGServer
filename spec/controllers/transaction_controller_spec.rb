require 'rails_helper'

RSpec.describe TransactionController, type: :controller do
  describe '#add_cards' do
    context 'with correct parameters' do
      let(:user_cards) do
        [
          { name: 'card1', quantity: '1', box_number: '1' },
          { name: 'card2', quantity: '1', box_number: '2' },
          { name: 'card3', quantity: '3', box_number: '1' }
        ]
      end
      let(:duplicate_card_error) do
        '1. You already have card1 in box 1 on the transaction tab'
      end

      context 'when the cards do not already exist' do
        it 'create and saves the cards' do
          post :add_cards, cards: user_cards

          expect(MyCard.all.pluck(:name)).to eq(['card1', 'card2', 'card3'])
          expect(MyCard.with_box_number(1).count).to eq(2)
          expect(MyCard.having_quantity(3).count).to eq(1)
        end
      end

      context 'when the cards already exist' do
        it 'should flash an error to the user' do
          MyCard.new(name: 'card1', quantity: 100, box: 1).save

          post :add_cards, cards: user_cards

          expect(flash[:error]).to eq([duplicate_card_error])
        end
      end
    end

    context 'with invalid parameters' do
      let(:invalid_user_card) do
        [
          { name: 'card1', quantity: 'a', box_number: '1' }
        ]
      end
      let(:multiple_invalid_user_cards) do
        [
          { name: 'card1', quantity: 'a', box_number: '1' },
          { quantity: 'a', box_number: 'qwe' }
        ]
      end
      let(:quantity_must_be_number_message) { '1. Quantity is not a number' }
      let(:multiple_error_messages) do
        [
          quantity_must_be_number_message,
          "2. Name can't be blank, Quantity is not a number, and Box is not a number"
        ]
      end

      context 'with invalid quantity' do
        it 'should flash an error ' do
          post :add_cards, cards: invalid_user_card

          expect(flash[:error]).to eq([quantity_must_be_number_message])
        end
      end

      context 'with multiple invalid fields' do
        it 'should flash an error ' do
          post :add_cards, cards: multiple_invalid_user_cards

          expect(flash[:error]).to eq(multiple_error_messages)
        end
      end
    end
  end
end
