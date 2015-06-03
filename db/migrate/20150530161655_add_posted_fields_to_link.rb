class AddPostedFieldsToLink < ActiveRecord::Migration
  def change
    add_column :links, :posted, :boolean, null: false, default: false
    add_column :links, :posted_at, :datetime, null: true
  end
end
