class UsersController < ApplicationController

  def show
    
  end

  private

  def user_params
    permit.require(:user).permit(:name, :role)
  end
end