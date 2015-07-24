class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @top_photos = Photo.top_photos(3)
    @challenge_photos = Photo.challenge_photos(@user)
    @photos = @user.photos
    @photo = Photo.new
  end

  private

  def user_params
    permit.require(:user).permit(:name, :role)
  end
end