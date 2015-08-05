class AddRankToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :rank, :float
  end
end
