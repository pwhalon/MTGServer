class AddSetInfoToMagicCard < ActiveRecord::Migration[5.2]
  def change
    add_column :magic_cards, :set_price_hash, :text
  end
end
