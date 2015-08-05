class FavoritePolicy < ApplicationPolicy

  def create?
    user
  end

  def destroy?
    create?
  end
end