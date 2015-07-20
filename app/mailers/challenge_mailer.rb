class ChallengeMailer < ApplicationMailer

  def results_email(photo, result)
    @photo = photo
    @result = result
    mail(to: @photo.user.email, subject: 'PhotoCha.mp results...')
  end
end
