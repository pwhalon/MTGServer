require 'validators/card_name_validator'

# Model for the entries in the MyCards database comprising the Name, Quantity, and Box location.
class MyCard < ActiveRecord::Base
  self.table_name = 'my_cards'

  CARDS_FOR_TRADE = [-1, -2].freeze

  has_many :deck_entries
  has_many :decks, through: :deck_entries

  has_one :magic_card

  validates :name, presence: true, card_name: true
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :box, presence: true, numericality: { only_integer: true }

  scope :with_box_number, ->(box_number) { where(box: box_number) }
  scope :with_name, ->(name) { where(name: name) }
  scope :having_quantity, ->(number) { where(quantity: number) }
  scope :cards_in_use, -> (id) { DeckEntry.where(my_card_id: id) }
  scope :cards_for_trade, -> { MyCard.with_box_number(CARDS_FOR_TRADE) }

  def magic_card
    MagicCard.find_by(name: self.name)
  end

  class << self
    def create_card(params)
      new_card = MyCard.new(name: params['name'],
        quantity: params['quantity'],
        box: params['box_number']
      )

      new_card.save if new_card.valid?

      return new_card
    end

    def make_transaction(transaction_params)
      card = self.first

      card.quantity = Integer(transaction_params['quantity']) + card.quantity

      card.save if card.valid?

      return card
    rescue ArgumentError
      card = self.first
      card.quantity = nil
      return card
    end
  end
end