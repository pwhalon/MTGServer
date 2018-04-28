# Model for the entries in the MyCards database comprising the Name, Quantity, and Box location.
class MyCard < ActiveRecord::Base
  self.table_name = 'my_cards'

  validates :name, presence: true
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :box, presence: true, numericality: { only_integer: true }

  scope :with_box_number, ->(box_number) { where(box: box_number) }
  scope :with_name, ->(name) { where(name: name) }
  scope :having_quantity, ->(number) { where(quantity: number) }

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