class ChangeUniqueIndexInvite < ActiveRecord::Migration
  def change
    remove_index :invites, name: "index_invites_on_referrer_id_and_email"
    add_index :invites, [:group_id, :referrer_id, :email], unique: true
  end
end
