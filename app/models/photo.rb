class Photo < ActiveRecord::Base

  mount_uploader :file, PhotoUploader

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reports, dependent: :destroy

  attr_accessor :new_category_name

  validates :name, presence: true
  validates :file, presence: true
  validates :user, presence: true
  validates :category, presence: true

  after_initialize :default_record
  before_save :create_category_from_name

  scope :top_photos, -> (limit) { 
    Photo.where("win > loss").order("rank DESC").includes(:category, :user).take(limit)
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
    self.update_rank
  end

  def lost
    self.update_attribute(:loss, loss + 1)
    self.update_rank
  end

  def tied
    self.update_attribute(:tie, tie + 1)
    self.update_rank
  end

  def in_challenge?
    Challenge.where("completed = ?", false).where("challenger_id = ? OR challenged_id = ?", self.id, self.id).any?
  end

  def update_rank
    new_rank = (2 * self.win) + self.tie
    age_in_days = (Time.now - self.created_at) / (60 * 60 * 24)
    new_rank += (10 - (age_in_days / 3)) if age_in_days < 30

    self.update_attribute(:rank, new_rank)
  end

  def send_reported_email
    ReportMailer.report(self).deliver_later if self.reports.count > 10
  end

  private

  def default_record
    self.win ||= 0
    self.loss ||= 0
    self.tie ||= 0
  end

  def create_category_from_name
    create_category(name: new_category_name) unless new_category_name.blank?
  end
end
