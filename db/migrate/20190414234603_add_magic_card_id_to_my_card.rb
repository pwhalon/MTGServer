class AddMagicCardIdToMyCard < ActiveRecord::Migration[5.2]
  def change
    add_column :my_cards, :magic_card_id, :integer
  end
end
