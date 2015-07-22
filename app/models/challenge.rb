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

  private

  def default_length
    self.length ||= 6
  end

  def complete_false
    self.complete = false
    true
  end

  def results_email
    if self.complete?
      photo_challenger = self.challenger
      photo_challenged = self.challenged
      if self.votes_challenger == self.votes_challenged
        ChallengeMailer.results_email(photo_challenger, 'tie')
        ChallengeMailer.results_email(photo_challenged, 'tie')
      elsif self.votes_challenger > self.votes_challenged
        ChallengeMailer.results_email(photo_challenger, 'win')
        ChallengeMailer.results_email(photo_challenged, 'lose')
      else
        ChallengeMailer.results_email(photo_challenged, 'win')
        ChallengeMailer.results_email(photo_challenger, 'lose')
      end
    end   
  end
end
