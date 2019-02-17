class AddColumnsToMagicCard < ActiveRecord::Migration
  def change
    add_column :magic_cards, :price, :string
    remove_column :magic_cards, :color, :string
  end
end
