class AddBasicFieldsToLevel < ActiveRecord::Migration
  def change
    add_column :levels, :blocks, :text
    add_column :levels, :start, :text
    add_column :levels, :entities, :text
  end
end
