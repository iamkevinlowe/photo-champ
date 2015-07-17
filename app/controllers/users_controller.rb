class UsersController < ApplicationController

  private

  def user_params
    permit.require(:user).permit(:name, :role)
  end
end