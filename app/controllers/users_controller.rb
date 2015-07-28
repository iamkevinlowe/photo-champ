class UsersController < ApplicationController

  def show
    Challenge.send_results
    @user = User.find(params[:id])
    @top_photos = Photo.top_photos(3)
    @challenges = Challenge.challenger_challenges(@user) + Challenge.challenged_challenges(@user)
    @photos = @user.photos
    @photo = Photo.new
  end

  private

  def user_params
    permit.require(:user).permit(:name, :role)
  end
end