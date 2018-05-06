class AddDeckToMyCard < ActiveRecord::Migration
  def change
    add_column :my_cards, :deck_id, :integer, null: true
  end
end
