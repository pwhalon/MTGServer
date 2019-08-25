module DeckHelper
  def self.deck_list(deck_id)
    Deck.cards(deck_id)
  end

  def self.my_card(card_id)
    MyCard.find(card_id)

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Failed to find card #{card_id} exception #{e}")
    'N/A'
  end

  def self.magic_card(card_name)
    MagicCard.find_by(name: card_name).first
  end
end
