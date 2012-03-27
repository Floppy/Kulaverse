class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :score
      t.references :level
      t.references :user

      t.timestamps
    end
    add_index :scores, :level_id
    add_index :scores, :user_id
  end
end
