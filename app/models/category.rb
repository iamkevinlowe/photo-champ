class Category < ActiveRecord::Base
  
  has_many :photos

  validates :name, presence: true
end
