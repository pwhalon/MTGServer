class RenameMagicCardColumns < ActiveRecord::Migration[5.2]
  def change
    # Rename image url column
    remove_column :magic_cards, :imageUrl, :string
    add_column :magic_cards, :image_url, :string

    # Rename multiverse id column
    remove_column :magic_cards, :multiverseId, :string
    add_column :magic_cards, :multiverse_id, :string

    # Rename mana cost column
    remove_column :magic_cards, :manaCost, :string
    add_column :magic_cards, :mana_cost, :string

    # Rename type column
    remove_column :magic_cards, :type, :string
    add_column :magic_cards, :card_type, :string
  end
end
