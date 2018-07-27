class AddAnimateToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :animate, :text

  end
end
