class CreateCardType < ActiveRecord::Migration
  def change
    create_table :card_types do |t|
      t.string :name
      t.integer :cmc
      t.string :color
      t.string :type
      t.string :rarity
      t.string :set
      t.string :imageUrl
    end
  end
end
