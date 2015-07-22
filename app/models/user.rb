class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true

  has_many :photos, dependent: :destroy

  after_initialize :default_role

  private

  def default_role
    self.role ||= 'standard'
  end
end
