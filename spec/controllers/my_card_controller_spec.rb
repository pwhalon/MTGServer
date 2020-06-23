require 'rails_helper'

RSpec.describe MyCardController, type: :controller do
  describe 'GET #search' do
    let!(:my_test_cards) do
      MagicCard.create!(name: 'card1')
      MagicCard.create!(name: 'card2')
      MagicCard.create!(name: 'card3')

      MyCard.create!(name: 'card1', quantity: 4, box: 3)
      MyCard.create(name: 'card2', quantity: 3, box: 1)
      MyCard.create(name: 'card3', quantity: 2, box: 5)

      Deck.create(name: 'deck')

      DeckEntry.create(deck_id: 1, my_card_id: 1)
    end

    context 'when search parameters do not match any of my cards' do
      it 'should return no search results in an empty relation' do
        get :search, magic_card_search: 'random_card'
        expect(controller.instance_variable_get(:@matching_cards)).to be_empty
      end

      it 'should render index' do
        get :search, magic_card_search: 'random_card'
        expect(response).to render_template(:index)
      end
    end

    context 'when search parameters match some of my cards' do
      it 'should return results in an active record relation' do
        get :search, magic_card_search: 'card1'

        expect(controller.instance_variable_get(:@matching_cards)).to eq(MyCard.where(name: 'card1'))

        expect(controller.instance_variable_get(:@deck_entries)).to eq([DeckEntry.where(my_card_id: 1)])
      end

      it 'should render index' do
        get :search, magic_card_search: 'random_card'
        expect(response).to render_template(:index)
      end
    end
  end
end
