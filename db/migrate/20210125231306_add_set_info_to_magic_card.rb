class AddSetInfoToMagicCard < ActiveRecord::Migration
  def change
    add_column :magic_cards, :set_price_hash, :text
  end
end
