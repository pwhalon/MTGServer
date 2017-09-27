require 'rails_helper'

RSpec.describe MagicController, type: :controller do
  describe 'GET #search' do
    let!(:my_test_cards) do
      MyCard.create(name: 'card1', quantity: 4, box: 3)
      MyCard.create(name: 'card2', quantity: 3, box: 1)
      MyCard.create(name: 'card3', quantity: 2, box: 5)
      MyCard.create(name: 'card4', quantity: 1, box: 2)
      MyCard.create(name: 'card2', quantity: 4, box: 3)
    end

    context 'when search parameters do not match any of my cards' do
      it 'should return no search results in an empty list' do
        get :search, magic_card_search: 'random_card'
        expect(controller.instance_variable_get(:@matching_cards)).to be_empty
      end

      it 'should render index' do
        get :search, magic_card_search: 'random_card'
        expect(response).to render_template(:index)
      end
    end

    context 'when search parameters match some of my cards' do
      it 'should return results in a list' do
        get :search, magic_card_search: 'card1'
        expect(controller.instance_variable_get(:@matching_cards)).to eq(MyCard.where(name: 'card1'))
      end

      it 'should render index' do
        get :search, magic_card_search: 'random_card'
        expect(response).to render_template(:index)
      end
    end
  end
end
