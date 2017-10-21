# Model for the entries in the MyCards database comprising the Name, Quantity, and Box location.
class MyCard < ActiveRecord::Base
  self.table_name = 'my_cards'

  validates :name, presence: true
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than: 0
  }
  validates :box, presence: true, numericality: { only_integer: true }

  scope :with_box_number, ->(box_number) { where(box: box_number) }
  scope :with_name, ->(name) { where(name: name) }
  scope :having_quantity, ->(number) { where(quantity: number) }
end