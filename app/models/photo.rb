class Photo < ActiveRecord::Base

  mount_uploader :url, PhotoUploader

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :name, presence: true
  validates :url, presence: true
  validates :user, presence: true
  validates :category, presence: true

  after_initialize :default_record

  scope :top_photos, -> (limit) { 
    Photo.where("win > loss").includes(:category, :user).take(limit)
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

  def won
    self.update_attribute(:win, win + 1)
  end

  def lost
    self.update_attribute(:loss, loss + 1)
  end

  def tied
    self.update_attribute(:tie, tie + 1)
  end

  def in_challenge?
    Challenge.active_challenges.where("challenger_id = ? OR challenged_id = ?", self.id, self.id).any?
  end

  private

  def default_record
    self.win ||= 0
    self.loss ||= 0
    self.tie ||= 0
  end
end
