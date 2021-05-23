class AddImageBackColumnToMagicCard < ActiveRecord::Migration
  def change
    add_column :magic_cards, :image_back, :string
  end
end
