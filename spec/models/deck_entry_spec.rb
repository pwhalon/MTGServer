require 'rails_helper'

RSpec.describe DeckEntry do
  let!(:setup_deck) do
    Deck.create(name: 'deck1', format: 'EDH')
  end

  let!(:setup_card) do
    MagicCard.create(name: 'card1')
    MyCard.create(name: 'card1', box: 1, quantity: 1)
  end

  describe 'valid?' do
    context 'when the deck card is valid' do
      it 'returns true' do
        expect(DeckEntry.new(deck_id: setup_deck.id, my_card_id: setup_card.id, quantity: 1).valid?).to be true
      end
    end

    context 'when there is no card id' do
      it 'returns false' do
        expect(DeckEntry.new(deck_id: setup_deck.id, quantity: 1).valid?).to be false
      end
    end

    context 'when there is no deck id' do
      it 'returns false' do
        expect(DeckEntry.new(my_card_id: setup_card.id, quantity: 1).valid?).to be false
      end
    end

    context 'when the quantity is in valid' do
      it 'returns false' do
        expect(DeckEntry.new(deck_id: setup_deck.id, my_card_id: setup_card.id, quantity: -1).valid?).to be false
      end
    end
  end
end