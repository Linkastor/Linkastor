class CreateUsersGroupsJoinTable < ActiveRecord::Migration
  def change
    create_table :groups_users, id: false do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
    end
    
    add_index :groups_users, :user_id
    add_index :groups_users, :group_id
  end
end
