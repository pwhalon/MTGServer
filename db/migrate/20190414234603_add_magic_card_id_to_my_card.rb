class AddMagicCardIdToMyCard < ActiveRecord::Migration
  def change
    add_column :my_cards, :magic_card_id, :integer
  end
end
