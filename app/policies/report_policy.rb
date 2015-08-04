class ReportPolicy < ApplicationPolicy

  def create?
    user && record.photo.user.id != user.id
  end

  def destroy?
    create?
  end
end