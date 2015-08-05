class UserPolicy < ApplicationPolicy

  def update?
    record == user &&
    record.role == 'admin'
  end
end