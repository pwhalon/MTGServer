module DeckHelper
  def self.deck_list(deck_id)
    Deck.cards(deck_id)
  end

  def self.card_name(card_id)
    MyCard.find(card_id).name

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Failed to find card #{card_id} exception #{e}")
    'N/A'
  end
end
