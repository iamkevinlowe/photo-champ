class ReportMailer < ApplicationMailer

  def report(photo)
    @photo = photo
    mail(to: @photo.user.email, subject: "PhotoChamp - Your photo has been reported")

    admins = User.where("role = ?", 'admin')
    admins.each do |admin|
      mail(to: admin.email, subject: "PhotoChamp - #{photo.user.email} has been reported")
    end
  end
end
