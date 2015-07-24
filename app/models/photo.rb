class Photo < ActiveRecord::Base

  mount_uploader :url, PhotoUploader

  belongs_to :user
  belongs_to :category
  # has_many :challenges

  after_initialize :default_record

  scope :top_photos, -> (limit) { Photo.where("win > loss").take(limit) }
  scope :challenge_photos, -> (user) { 
    photo_ids = user.photo_ids
    Photo.find(
      Challenge.where(completed: false, challenger_id: photo_ids).pluck(:challenger_id) +
      Challenge.where(completed: false, challenged_id: photo_ids).pluck(:challenged_id)
    )
  }

  private

  def default_record
    self.win ||= 0
    self.loss ||= 0
    self.tie ||= 0
  end
end
