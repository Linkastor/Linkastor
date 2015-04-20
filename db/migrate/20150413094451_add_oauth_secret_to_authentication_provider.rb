class AddOauthSecretToAuthenticationProvider < ActiveRecord::Migration
  def change
    add_column :authentication_providers, :secret, :string, null: false
  end
end
