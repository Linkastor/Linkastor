class UniqGroupsPerUser < ActiveRecord::Migration
  def change
    remove_index :groups_users, :user_id
    remove_index :groups_users, :group_id
    
    add_index :groups_users, [:user_id, :group_id], unique: true
  end
end
