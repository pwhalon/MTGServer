require 'rails_helper'

RSpec.describe DeckController, type: :controller do
  describe '#index' do
    let!(:setup_decks) do
      Deck.new(name: 'deck1', format: 'EDH').save!
      Deck.new(name: 'deck2', format: 'Modern').save!
      Deck.new(name: 'deck3', format: 'Standard').save!
    end

    it 'returns a list of all decks' do
      get :index

      expect(response).to render_template(:index)
      expect(assigns(:decks)).to eq(Deck.all.to_a)
    end
  end

  describe '#new' do
    it 'returns a new Deck instance' do
      expect(Deck).to receive(:new)

      get :new

      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    context 'when the form is correct' do
      let(:deck1) { 'deck1' }

      context 'when the correct parameters are provided' do
        it 'creates the deck and redirects to index' do
          get :create,
              deck: { name: deck1, format: 'EDH' }

          expect(Deck.where(name: deck1).pluck(:name)).to eq([deck1])
          expect(response).to redirect_to(action: :index)
        end
      end

      context 'when a parameter is missing' do
        it 'does not create the deck and redirects to new' do
          get :create,
              deck: { name: deck1 }

          expect(Deck.where(name: deck1).pluck(:name)).to eq([])
          expect(response).to redirect_to(action: :new)
        end
      end
    end
  end
end
