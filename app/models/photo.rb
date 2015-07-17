class Photo < ActiveRecord::Base

  mount_uploader :url, PhotoUploader

  belongs_to :user
  belongs_to :category
end
