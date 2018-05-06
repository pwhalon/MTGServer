# Model for the entries in the MagicCard database table comprising the Name,
# manaCost, cmc, color, type, rarity, imageUrl, and multiverseId.
class MagicCard < ActiveRecord::Base
  self.table_name = 'magic_cards'

  validates :name, presence: true, uniqueness: true

  scope :with_name, ->(name) { where(name: name) }
end