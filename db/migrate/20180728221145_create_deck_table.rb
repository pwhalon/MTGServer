class CreateDeckTable < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :name
      t.string :format
    end
  end
end
