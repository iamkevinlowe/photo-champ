class CommentPolicy < ApplicationPolicy

  def create?
    user
  end

  def destroy?
    if user
      record.user == user ||
      user.role == 'admin'
    end
  end
end