class CreateCustomSource < ActiveRecord::Migration
  def change
    create_table :custom_sources do |t|
      t.string        :name,      null: false
      t.string        :type,      null: false
      t.jsonb         :extra,     null: false
      t.timestamps                null: false
    end
    
    create_table :custom_sources_users, id: false do |t|
      t.integer :user_id,                   null: false
      t.integer :custom_source_id,          null: false
    end
    add_index :custom_sources_users, [:user_id, :custom_source_id], unique: true
  end
end
