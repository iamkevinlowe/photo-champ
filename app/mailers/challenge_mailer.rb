class ChallengeMailer < ApplicationMailer

  def new_challenge(challenge)
    @challenge = challenge
    mail(to: @challenge.challenged.user.email, subject: "PhotoCha.mp - #{@challenge.challenger.user.name} wants to challenge you!")
  end

  def results_email(photo, result)
    @photo = photo
    @result = result
    mail(to: @photo.user.email, subject: 'PhotoCha.mp results...')
  end
end
