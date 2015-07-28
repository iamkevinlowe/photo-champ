module CategoriesHelper

  # Randomly picks unique photos for index view
  def photos_array(photos)
    @category_photos = photos.to_a
  end

  def photo_from_array
    @category_photos.delete_at(rand(@category_photos.count))
  end
end