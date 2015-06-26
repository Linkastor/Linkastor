class AddUniqueConstraintsToLinks < ActiveRecord::Migration
  def change
    add_index :links, [:group_id, :url], unique: true
    add_index :links, [:custom_source_id, :url], unique: true
  end
end
