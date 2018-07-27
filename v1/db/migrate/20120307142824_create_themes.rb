class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.string :texture_sky
      t.string :texture_block
      t.string :texture_ball
      t.timestamps
    end
  end
end
