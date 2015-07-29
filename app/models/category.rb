class Category < ActiveRecord::Base
  
  has_many :photos

  def photos
    Photo.where("category_id = ?", self.id).includes(:user, :category)
  end
end
