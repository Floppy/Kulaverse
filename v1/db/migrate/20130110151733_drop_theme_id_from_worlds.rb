class DropThemeIdFromWorlds < ActiveRecord::Migration
  def change
    remove_column :worlds, :theme_id
  end
end
