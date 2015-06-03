class AddPostedByToLink < ActiveRecord::Migration
  def change
    add_column :links, :posted_by, :integer, null: false
  end
end
