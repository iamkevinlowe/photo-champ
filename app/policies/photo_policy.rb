class PhotoPolicy < ApplicationPolicy

  def new?
    if user.role == 'standard'
      user.photos.count < 5
    elsif user.role == 'premium'
      user.photos.count < 20
    elsif user.role == 'admin'
      return true
    end
  end

  def create?
    new?
  end

  def edit?
    record.user == user ||
    user.role == 'admin'
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end