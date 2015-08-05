class ChallengePolicy < ApplicationPolicy

  def new?
    user && 
    user != record.challenged.user && 
    user.photos.pluck(:category_id).include?(record.challenged.category_id)
  end

  def create?
    Challenge.where("completed = ?", false).where("challenger_id = ? AND challenged_id = ?", record.challenger_id, record.challenged_id).empty? &&
    Challenge.where("completed = ?", false).where("challenger_id = ? AND challenged_id = ?", record.challenged_id, record.challenger_id).empty?
  end

  def vote?
    unless record.completed?
      record.ends_at? && record.ends_at > Time.now
    end
  end

  def accept?
    user &&
    user == record.challenged.user
  end
end