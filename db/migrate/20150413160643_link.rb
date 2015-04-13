class Link < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :group_id,    null: false
      t.string  :url,         null: false
      t.string  :title,       null: false
      t.timestamps            null: false
    end
    
    add_index :links, :group_id
    add_index :links, [:url, :created_at]
  end
end
