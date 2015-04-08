class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :referrer,  null: false
      t.integer :referee,   null: false
      t.string  :code,      null: false
      t.boolean :accepted,  null: false, default: false
    end
    
    add_index :invites, [:referrer, :referee], unique: true
    add_index :invites, :code
  end
end
