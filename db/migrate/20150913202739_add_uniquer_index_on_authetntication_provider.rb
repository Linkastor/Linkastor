class AddUniquerIndexOnAuthetnticationProvider < ActiveRecord::Migration
  def change
    remove_index :authentication_providers, :user_id
    add_index :authentication_providers, [:user_id, :provider], unique: true
  end
end