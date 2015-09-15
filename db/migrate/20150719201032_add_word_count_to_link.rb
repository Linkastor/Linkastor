class AddWordCountToLink < ActiveRecord::Migration
  def change
    add_column :links, :wordcount, :integer, null: true
  end
end
