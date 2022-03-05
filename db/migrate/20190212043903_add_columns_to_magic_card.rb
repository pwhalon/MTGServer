class AddColumnsToMagicCard < ActiveRecord::Migration[5.2]
  def change
    add_column :magic_cards, :price, :string
    remove_column :magic_cards, :color, :string
  end
end
