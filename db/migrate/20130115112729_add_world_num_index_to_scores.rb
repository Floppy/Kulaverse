class AddWorldNumIndexToScores < ActiveRecord::Migration
  def change
    add_index :scores, :world_num
  end
end
