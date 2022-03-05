class CreateMyCards < ActiveRecord::Migration[5.2]
  def change
    create_table :my_cards do |t|
      t.string :name
      t.integer :quantity
      t.integer :box
    end
  end
end
