class AddMetaToLink < ActiveRecord::Migration
  def change
    add_column :links, :image_url, :string, null: true
    add_column :links, :description, :text, null: true
  end
end
