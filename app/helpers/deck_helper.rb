module DeckHelper
  def self.deck_list(deck_id)
    Deck.cards(deck_id)
  end
end
