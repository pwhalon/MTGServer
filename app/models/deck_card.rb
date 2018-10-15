# Model to represent the connection between a card in the database and the deck that it is a part of
# along with how many of that card are in the deck.
class DeckCard < ActiveRecord::Base
  self.table_name = 'deck_cards'

  has_many :decks

  has_many :my_cards, foreign_key: :id
end