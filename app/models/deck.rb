# Model for the entries in the Deck table in the database,
# comprised of list of associated cards in the deck.
class Deck < ActiveRecord::Base
  self.table_name = 'decks'

  MTG_FORMATS = %w(EDH Modern Standard).freeze

  validates :name, presence: true
  validates :format, presence: true, inclusion: {
    in: MTG_FORMATS,
    message: "Error format must be one of #{MTG_FORMATS}"
  }

  has_many :deck_cards

  has_many :my_cards, through: :deck_cards

  scope :cards, ->(id) { DeckCard.joins('INNER JOIN decks ON deck_cards.deck_id = decks.id').where(deck_id: id) }
end