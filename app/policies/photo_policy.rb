class PhotoPolicy < ApplicationPolicy

  def new?
    if user.role == 'standard'
      user.images.count < 5
    elsif user.role == 'premium'
      user.images.count < 20
    elsif user.role == 'admin'
      return true
    end
  end

  def create?
    new?
  end
end