class DropThemes < ActiveRecord::Migration
  def change
    drop_table :themes
  end
end
