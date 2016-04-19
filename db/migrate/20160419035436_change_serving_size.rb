class ChangeServingSize < ActiveRecord::Migration
  def change
    change_column(:ingredients, :serving_size, :float )
  end
end
