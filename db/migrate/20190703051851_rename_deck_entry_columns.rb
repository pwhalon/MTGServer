class RenameDeckEntryColumns < ActiveRecord::Migration
  def change
    rename_column :deck_entries, :card_id, :my_card_id
  end
end
