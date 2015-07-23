class ChallengePolicy < ApplicationPolicy

  def create?
    record.challenger.category == record.challenged.category
  end
end