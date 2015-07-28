class Photo < ActiveRecord::Base

  mount_uploader :url, PhotoUploader

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  after_initialize :default_record

  scope :top_photos, -> (limit) { 
    Photo.where("win > loss").take(limit) 
  }

  scope :challenge_photos, -> (user) { 
    photo_ids = user.photo_ids
    Photo.find(
      Challenge.challenger_challenges(user).pluck(:challenger_id) +
      Challenge.challenged_challenges(user).pluck(:challenged_id)
    )
  }

  scope :new_challenge_photos, -> (user, challenged) { 
    Photo.where("user_id = ? AND category_id = ?", user.id, challenged.category_id)
  }

  private

  def default_record
    self.win ||= 0
    self.loss ||= 0
    self.tie ||= 0
  end
end
