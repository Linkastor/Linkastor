class AddWordCountToLink < ActiveRecord::Migration
  def change
    add_column :links, :wordcount, :integer, default: 0
  end
end
