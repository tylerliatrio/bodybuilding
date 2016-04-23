class ChangeFatsType < ActiveRecord::Migration
  def change
    change_column(:ingredients,:fats, :float)
  end
end
