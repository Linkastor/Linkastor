class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.text :content, null: false
      t.integer :link_id, null: false

      t.timestamps null: false
    end

    add_index :comments, :link_id
    add_index :comments, :user_id
  end
end
