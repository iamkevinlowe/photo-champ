class ChallengePolicy < ApplicationPolicy

  def new?
    user && 
    record.challenged.user != user && 
    user.photos.pluck(:category_id).include?(record.challenged.category_id)
  end

  def create?
    record.challenger.category == record.challenged.category
  end

  def vote?
    record.ends_at > Time.now
  end
end