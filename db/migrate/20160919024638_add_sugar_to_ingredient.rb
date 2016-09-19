class AddSugarToIngredient < ActiveRecord::Migration
  def change
    add_column Ingredient, :sugar, :integer
  end
end
