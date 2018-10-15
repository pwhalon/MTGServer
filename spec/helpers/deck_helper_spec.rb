require 'rails_helper'

RSpec.describe DeckHelper, type: :helper do
  let!(:setup_deck) do
    Deck.create(name: 'deck3', format: 'Standard')
  end

  let!(:setup_cards) do
    MyCard.create(name: 'card1', quantity: 4, box: 3)
    MyCard.create(name: 'card2', quantity: 3, box: 1)
    MyCard.create(name: 'card3', quantity: 2, box: 5)
  end

  let!(:setup_deck_cards) do
    DeckCard.create(card_id: 1, deck_id: 1, quantity: 1)
    DeckCard.create(card_id: 3, deck_id: 1, quantity: 2)
  end

  describe '#deck_list' do
    context 'when there are cards that are on the deck list' do
      it 'returns those cards in a list' do
        expect(DeckHelper.deck_list(setup_deck.id).pluck(:id)).to eq(DeckCard.where(deck_id: setup_deck.id).pluck(:id))
      end
    end

    context 'when there are no cards on the deck list' do
      it 'returns an empty list' do
        expect(DeckHelper.deck_list(0).pluck(:id)).to eq([])
      end
    end
  end
end
