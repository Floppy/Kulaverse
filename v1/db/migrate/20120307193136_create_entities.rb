class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :name
      t.text :mesh
      t.text :collide
      t.timestamps
    end
  end
end
