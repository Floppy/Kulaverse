class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.references :theme
      t.string :name
      t.timestamps
    end
    add_index :worlds, :theme_id
  end
end
