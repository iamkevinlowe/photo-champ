class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true

  has_many :photos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reports, dependent: :destroy

  after_initialize :default_role

  def favorited(photo)
    favorites.where("photo_id = ?", photo.id).first
  end

  def reported(photo)
    reports.where("photo_id = ?", photo.id).first
  end

  def active_for_authentication?
    super && !self.banned
  end

  private

  def default_role
    self.role ||= 'standard'
  end
end
