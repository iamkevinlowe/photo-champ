class ChallengeMailer < ApplicationMailer

  def new_challenge(challenge)
    @challenge = challenge
    mail(to: @challenge.challenged.user.email, subject: "PhotoCha.mp - #{@challenge.challenger.user.name} wants to challenge you!")
  end

  def challenge_accepted(challenge)
    @challenge = challenge
    mail(to: @challenge.challenger.user.email, subject: "PhotoCha.mp - Let the games begin!")   
  end

  def results_email(photo, result)
    @photo = photo
    @result = result
    mail(to: @photo.user.email, subject: 'PhotoCha.mp - The results...')
  end
end
