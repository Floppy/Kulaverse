class AddWorldNumToScores < ActiveRecord::Migration
  def change
    rename_column :scores, :level_id, :level_num
    add_column :scores, :world_num, :integer
  end
end
