class Photo < ActiveRecord::Base

  mount_uploader :url, PhotoUploader

  belongs_to :user
  belongs_to :category
  # has_many :challenges

  scope :top_photos, -> (limit) { Photo.where("win > loss").take(limit) }
  scope :challenge_photos, -> (user) { 
    photo_ids = user.photo_ids
    Photo.find(
      Challenge.where(complete: false, challenger_id: photo_ids).pluck(:challenger_id) +
      Challenge.where(complete: false, challenged_id: photo_ids).pluck(:challenged_id))
  }
end
