class RenameServingSizeToUnits < ActiveRecord::Migration
  def change
    rename_column(:ingredients,:serving_type,:units)
  end
end
