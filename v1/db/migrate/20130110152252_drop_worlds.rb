class DropWorlds < ActiveRecord::Migration
  def change
    drop_table :worlds
    rename_column :levels, :world_id, :world_num
    add_column :levels, :level_num, :integer
  end
end
