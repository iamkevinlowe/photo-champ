class Category < ActiveRecord::Base
  
  has_many :photos

  validates :name, presence: true

  def photos
    Photo.where("category_id = ?", self.id).includes(:user, :category)
  end
end
