class AddCustomSourceToLink < ActiveRecord::Migration
  def change
    add_column :links, :custom_source_id, :integer, null: true
    change_column :links, :group_id, :integer, null: true
    change_column :links, :posted_by, :integer, null: true
  end
end
