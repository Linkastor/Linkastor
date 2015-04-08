class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string      :email,     null: true
      t.string      :name,      null: true
      t.string      :avatar,    null: true
      t.timestamps              null: false
    end
    
    add_index :users, :email, unique: true
  end
end
