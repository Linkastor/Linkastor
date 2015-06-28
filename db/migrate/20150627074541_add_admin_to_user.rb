class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    User.where(email: ["vdaubry@gmail.com", "thibault@lelevier.fr"]).update_all(admin: true)
  end
end
