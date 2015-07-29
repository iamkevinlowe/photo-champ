class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: "Photo"
  belongs_to :challenged, class_name: "Photo"

  before_create :default_val

  scope :challenger_challenges, -> (user) {
    Challenge.where(completed: false, challenger_id: user.photo_ids).includes(:challenger, :challenged)
  }

  scope :challenged_challenges, -> (user) {
    Challenge.where(completed: false, challenged_id: user.photo_ids).includes(:challenger, :challenged)
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
      challenger.update_attribute(:tie, tie + 1)
      challenged.update_attribute(:tie, tie + 1)
    else
      winner.update_attribute(:win, win + 1)
      loser.update_attribute(:loss, loss + 1)
    end
  end

  def results_email
    if draw?
      ChallengeMailer.results_email(self.challenger, 'tie').deliver
      ChallengeMailer.results_email(self.challenged, 'tie').deliver
    else
      ChallengeMailer.results_email(winner, 'win').deliver
      ChallengeMailer.results_email(loser, 'lose').deliver
    end
  end
end
