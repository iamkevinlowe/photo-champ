class CategoryPolicy < ApplicationPolicy

  def create?
    if user
      user.role == 'premium' || user.role == 'admin'
    end
  end

  def update?
    create?
  end

  def destroy?
    user && user.role == 'admin'
  end
end
