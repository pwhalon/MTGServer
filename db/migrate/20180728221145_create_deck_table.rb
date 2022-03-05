class CreateDeckTable < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.string :name
      t.string :format
    end
  end
end
