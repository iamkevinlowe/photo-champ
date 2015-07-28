class ChangeColumnFavorites < ActiveRecord::Migration
  def change
    rename_column :favorites, :photos_id, :photo_id
  end
end
