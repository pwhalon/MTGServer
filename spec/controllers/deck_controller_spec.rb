require 'rails_helper'

RSpec.describe DeckController, type: :controller do
  describe '#index' do
    let!(:setup_decks) do
      Deck.create(name: 'deck1', format: 'EDH')
      Deck.create(name: 'deck2', format: 'Modern')
      Deck.create(name: 'deck3', format: 'Standard')
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

  describe '#delete' do
    let!(:create_deck) do
      d1 = Deck.create(name: 'deck1', format: 'EDH')

      c1 = MyCard.create(name: 'card1')

      DeckEntry.create(my_card_id: c1, deck_id: d1)
    end

    context 'with a non-existent deck id' do
      it 'sets the flash error and returns' do
        get :delete, params: { 'id' => 100 }

        expect(flash[:error]).to eq('Invalid deck id. Unable to delete non-existent deck.')
      end
    end

    context 'when the deckid exists' do
      it 'deletes the deck and associated deck entries' do
        get :delete, params: { 'id' => 1 }

        expect(flash[:success]).to eq('Success! Deleted deck and associated deck entries.')

        expect(Deck.all).to be_empty

        expect(DeckEntry.all).to be_empty
      end
    end
  end

  describe '#create' do
    context 'when the form is correct' do
      let(:deck1) { 'deck1' }

      context 'when the correct parameters are provided' do
        it 'creates the deck and redirects to index' do
          get :create, params: { deck: { name: deck1, format: 'EDH' } }

          expect(Deck.where(name: deck1).pluck(:name)).to eq([deck1])
          expect(response).to redirect_to(action: :index)
        end
      end

      context 'when a parameter is missing' do
        it 'does not create the deck and redirects to new' do
          get :create, params: { deck: { name: deck1 } }

          expect(Deck.where(name: deck1).pluck(:name)).to eq([])
          expect(response).to redirect_to(action: :new)
        end
      end
    end
  end

  describe '#add_cards' do
    let!(:deck) { Deck.create(name: 'deck1', format: 'EDH') }
    let!(:magic_card) { MagicCard.create(name: 'card1') }
    let!(:my_card) { MyCard.create(name: 'card1', quantity: 1, box: 1) }

    let(:card_form) do
      [
        {
          deckId: deck.id,
          name: my_card.name,
          box: my_card.box,
          quantity: 1
        }
      ]
    end

    context 'when all parameters are provided' do
      context 'when the parameters are valid' do
        it 'adds the card to the deck' do
          get :add_cards, params: { cards: card_form }

          expect(DeckEntry.all.count).to eq(card_form.count)
          expect(DeckEntry.all.pluck(:my_card_id)).to eq([my_card.id])
        end

        context 'when there are multiple cards to add' do
          let!(:another_card) { MyCard.create(name: 'card1', quantity: 2, box: 2) }

          it 'adds them to the deck' do
            card_form.push({deckId: deck.id, name: another_card.name, box: another_card.box, quantity: 1 })

            get :add_cards, params: { cards: card_form }

            expect(DeckEntry.all.count).to eq(card_form.count)
            expect(DeckEntry.all.pluck(:my_card_id)).to eq([my_card.id, another_card.id])
            expect(MyCard.cards_in_use(another_card.id).pluck(:quantity)).to eq([1])
          end
        end
      end

      context 'when the quantity desired is higher than the availible cards quantity' do
        it 'returns bad request' do
          card_form.first.merge!(quantity: 3)

          get :add_cards, params: { cards: card_form }

          expect(response.status).to be 400
          expect(JSON.parse(response.body)['errors'].first).to match(/is greater than that cards available quantity/)

          expect(DeckEntry.all.count).to eq(0)
        end
      end

      context 'when a parameter is invalid' do
        it 'returns bad request' do
          card_form.first.merge!(quantity: 'a')

          get :add_cards, params: { cards: card_form }

          expect(response.status).to be 400
          expect(JSON.parse(response.body)['errors'].first).to match(/is not a valid quantity to add/)

          expect(DeckEntry.all.count).to eq(0)
        end
      end

      context 'when a parameter is missing' do
        context 'when the deck id is missing' do
          it 'returns bad request' do
            card_form.first.merge!(deckId: nil)

            get :add_cards, params: { cards: card_form }

            expect(response.status).to be 400
            expect(JSON.parse(response.body)['errors'].first).to match(/Deck can't be blank/)

            expect(DeckEntry.all.count).to eq(0)
          end
        end
      end
    end
  end
end
