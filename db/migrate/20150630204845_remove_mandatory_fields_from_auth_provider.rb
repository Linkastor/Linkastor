class RemoveMandatoryFieldsFromAuthProvider < ActiveRecord::Migration
  def change
    change_column :authentication_providers, :secret, :string, null: true
  end
end
