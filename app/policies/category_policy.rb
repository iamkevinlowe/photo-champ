class CategoryPolicy < ApplicationPolicy

  def new?
    user.role == 'premium' || user.role == 'admin'
  end

  def create?
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end
end
