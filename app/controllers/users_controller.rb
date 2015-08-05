class UsersController < ApplicationController

  def show
    Challenge.send_results
    @user = User.find(params[:id])
    @top_photos = Photo.top_photos(4)
    @challenges = Challenge.challenger_challenges(@user).includes(:challenger, :challenged) + Challenge.challenged_challenges(@user).includes(:challenger, :challenged)
    @favorites = Photo.where(id: @user.favorites.pluck(:photo_id)).includes(:category, :user)
    @photos = @user.photos.includes(:category)
    @photo = Photo.new
  end

  def update
    admin = User.find(params[:admin_id])
    @user = User.find(params[:id])
    authorize admin
    if @user.update_attributes(user_params)
      flash[:notice] = "The user has been updated."
    else
      flash[:error] = "Something went wrong. Please try again."
    end
    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:name, :role, :banned)
  end
end