class AddImageBackColumnToMagicCard < ActiveRecord::Migration[5.2]
  def change
    add_column :magic_cards, :image_back, :string
  end
end
