# Model for the entries in the MagicCard database table comprising the Name,
# manaCost, cmc, color, type, rarity, imageUrl, and multiverseId.
class MagicCard < ActiveRecord::Base
  self.table_name = 'magic_cards'

  has_one :my_card, foreign_key: :name

  validates :name, presence: true, uniqueness: true

  scope :with_name, ->(name) { where(name: name) }
end