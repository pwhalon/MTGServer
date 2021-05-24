require 'rails_helper'

RSpec.describe TransactionController, type: :controller do
  let!(:setup_magic_cards) do
    (1..3).each { |iterator| MagicCard.create(name: "card#{iterator}") }
  end

  describe '#transaction' do
    context 'with correct parameters' do
      let(:user_cards) do
        [
          { name: 'card1', quantity: '1', box_number: '1' },
          { name: 'card2', quantity: '1', box_number: '2' },
          { name: 'card3', quantity: '3', box_number: '1' }
        ].to_json
      end

      context 'when the cards do not already exist' do
        it 'create and saves the cards' do
          post :transaction, params: { 'list' => user_cards }

          expect(MyCard.all.pluck(:name)).to eq(['card1', 'card2', 'card3'])
          expect(MyCard.with_box_number(1).count).to eq(2)
          expect(MyCard.having_quantity(3).count).to eq(1)
        end
      end

      context 'when the cards already exist' do
        it 'should increase the quantity of the card' do
          MyCard.new(name: 'card1', quantity: 100, box: 1).save

          post :transaction, params: { list: user_cards }

          expect(MyCard.all.pluck(:name)).to eq(['card1', 'card2', 'card3'])
          expect(MyCard.with_name('card1').pluck(:quantity).first).to eq(101)
        end
      end
    end

    context 'with invalid parameters' do
      let(:invalid_user_card) do
        [
          { name: 'card1', quantity: 'a', box_number: '1' }
        ].to_json
      end

      let(:multiple_invalid_user_cards) do
        [
          { name: 'card1', quantity: 'a', box_number: '1' },
          { quantity: 'a', box_number: 'qwe' }
        ].to_json
      end

      let(:quantity_must_be_number_message) { 'Quantity is not a number' }
      let(:multiple_error_messages) do
        [
          quantity_must_be_number_message,
          "Name can't be blank, Quantity is not a number, and Box is not a number"
        ]
      end

      context 'with invalid quantity' do
        it 'should flash an error ' do
          post :transaction, params: { 'list' => invalid_user_card }

          expect(response).to be_bad_request
          expect(JSON.parse(response.body).first['error']).to eq(quantity_must_be_number_message)
        end
      end

      context 'with multiple invalid fields' do
        it 'should flash an error ' do
          post :transaction, params: { 'list' => multiple_invalid_user_cards }

          expect(response).to be_bad_request
          expect(JSON.parse(response.body).map{ |transaction| transaction['error'] }).to eq(multiple_error_messages)
        end
      end
    end
  end
end
