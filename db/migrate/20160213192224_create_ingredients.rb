class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :serving_type
      t.integer :serving_size
      t.integer :prots
      t.integer :carbs
      t.integer :fats
      t.integer :cals

      t.timestamps null: false
    end
  end
end
