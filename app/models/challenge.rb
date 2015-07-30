class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: "Photo"
  belongs_to :challenged, class_name: "Photo"

  before_create :default_val

  scope :challenger_challenges, -> (user) {
    Challenge.active_challenges.where(challenger_id: user.photo_ids)
  }
  scope :challenged_challenges, -> (user) {
    Challenge.active_challenges.where(challenged_id: user.photo_ids)
  }
  scope :active_challenges, -> {
    Challenge.where("completed = ?", false).where.not(ends_at: nil)
  }

  def self.send_results
    Challenge.where("ends_at < ? AND completed = ?", Time.now, false).each{ |challenge| challenge.complete! }
  end

  def winner
    if self.completed? && !draw?
      self.votes_challenger > self.votes_challenged ? self.challenger : self.challenged
    end
  end

  def loser
    if self.completed? && !draw?
      self.votes_challenger < self.votes_challenged ? self.challenger : self.challenged
    end
  end

  def draw?
    return true if self.completed? && self.votes_challenger == self.votes_challenged
  end

  def start!
    self.update_attribute(:ends_at, Time.now + length.hours)
  end

  def complete!
    self.update_attributes(completed: true)
    update_scores
    results_email
  end

  def vote_for(someone)
    if someone == 'challenger'
      self.update_attribute(:votes_challenger, votes_challenger + 1)
    elsif someone == 'challenged'
      self.update_attribute(:votes_challenged, votes_challenged + 1)
    end
  end

  private

  def default_val
    self.completed = false
    self.votes_challenger = 0
    self.votes_challenged = 0
  end

  def update_scores
    if draw?
      challenger.tie
      challenged.tie
    else
      winner.won
      loser.lost
    end
  end

  def results_email
    if draw?
      ChallengeMailer.results_email(self.challenger, 'tie').deliver_later
      ChallengeMailer.results_email(self.challenged, 'tie').deliver_later
    else
      ChallengeMailer.results_email(winner, 'win').deliver_later
      ChallengeMailer.results_email(loser, 'lose').deliver_later
    end
  end
end
