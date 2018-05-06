class CreateMagicCard < ActiveRecord::Migration
  def change
    create_table :magic_cards do |t|
      t.string :name
      t.integer :cmc
      t.string :color
      t.string :manaCost
      t.string :type
      t.string :rarity
      t.string :imageUrl
      t.integer :multiverseId
    end
  end
end
