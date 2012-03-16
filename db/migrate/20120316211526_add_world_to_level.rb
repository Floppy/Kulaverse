class AddWorldToLevel < ActiveRecord::Migration
  def change
    add_column :levels, :world_id, :integer
  end
end
