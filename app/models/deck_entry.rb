# Model to represent the connection between a card in the database and the deck that it is a part of
# along with how many of that card are in the deck.
class DeckEntry < ActiveRecord::Base
  self.table_name = 'deck_entries'

  belongs_to :deck
  belongs_to :my_card

  validates :deck_id, presence: true
  validates :my_card_id, presence: true
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
end