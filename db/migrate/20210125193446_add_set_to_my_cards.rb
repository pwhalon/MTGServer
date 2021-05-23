class AddSetToMyCards < ActiveRecord::Migration[5.2]
  def change
    add_column :my_cards, :set_code, :string
  end
end
