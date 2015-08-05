class AdminsController < ApplicationController
  before_action :allowed?

  def index
    @banned_users = User.where("banned = ?", true)
    @reported_photos = Hash.new(0)
    Report.all.includes(photo: [:user]).each { |report| @reported_photos[report.photo] += 1 }
  end
  
  private

  def allowed?
    if current_user.nil? || current_user.role != 'admin'
      flash[:error] = "You are not an administrator."
      redirect_to (request.referrer || root_path)
    end
  end
end