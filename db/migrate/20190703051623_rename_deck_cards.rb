class RenameDeckCards < ActiveRecord::Migration
  def change
    rename_table :deck_cards, :deck_entries
  end
end
