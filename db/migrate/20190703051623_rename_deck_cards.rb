class RenameDeckCards < ActiveRecord::Migration[5.2]
  def change
    rename_table :deck_cards, :deck_entries
  end
end
