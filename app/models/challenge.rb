class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: "Photo"
  belongs_to :challenged, class_name: "Photo"

  before_create :default_val

  scope :challenger_challenges, -> (user) {
    Challenge.where(completed: false, challenger_id: user.photo_ids)
  }

  scope :challenged_challenges, -> (user) {
    Challenge.where(completed: false, challenged_id: user.photo_ids)
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

  def complete!
    self.update_attributes(completed: true)
    update_scores
    results_email
  end

  private

  def default_val
    self.votes_challenger = 0
    self.votes_challenged = 0
    self.completed = false
    self.ends_at = Time.now + self.length.hours
  end

  def update_scores
    if draw?
      challenger.tie += 1
      challenger.save!
      challenged.tie += 1
      challenged.save!
    else
      winner.win += 1
      winner.save!
      loser.loss += 1
      loser.save!
    end
  end

  def results_email
    if draw?
      ChallengeMailer.results_email(self.challenger, 'tie')
      ChallengeMailer.results_email(self.challenged, 'tie')
    else
      ChallengeMailer.results_email(winner, 'win')
      ChallengeMailer.results_email(loser, 'lose')
    end
  end
end
