class CategoryPolicy < ApplicationPolicy

  def new?
    if user.present?
      user.role == 'premium' || user.role == 'admin'
    end
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def destroy?
    user.present? && user.role == 'admin'
  end
end
