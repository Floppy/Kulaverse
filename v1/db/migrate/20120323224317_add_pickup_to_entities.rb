class AddPickupToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :pickup, :boolean, :default => false
  end
end
