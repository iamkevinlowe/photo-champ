class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: "Photo"
  belongs_to :challenged, class_name: "Photo"

  before_create :default_length
  before_create :complete_false
  after_update :results_email

  def self.send_results
    Challenge.where("ends_at < ? AND completed = ?", Time.now, false).each do |challenge|
      challenge.complete!
    end
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

  private

  def default_length
    self.length ||= 6
  end

  def complete_false
    self.completed = false
    self.ends_at = Time.now + self.length.hours
  end

  def complete!
    self.completed = true
    results_email
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
