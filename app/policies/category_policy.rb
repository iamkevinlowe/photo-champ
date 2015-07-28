class CategoryPolicy < ApplicationPolicy

  def create?
    if user.present?
      user.role == 'premium' || user.role == 'admin'
    end
  end

  def update?
    create?
  end

  def destroy?
    user.present? && user.role == 'admin'
  end
end
