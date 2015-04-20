class AddMissingTimeStamps < ActiveRecord::Migration
  def change
    Invite.destroy_all
    add_column :invites, :created_at, :datetime, null: false
    add_column :invites, :updated_at, :datetime, null: false
    
    Group.destroy_all
    add_column :groups, :created_at, :datetime, null: false
    add_column :groups, :updated_at, :datetime, null: false
  end
end
