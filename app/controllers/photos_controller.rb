class PhotosController < ApplicationController

  def index
    
  end

  def show

  end

  def new
    
  end

  def create
    
  end

  def destroy
    
  end

  private

  def photo_params
    params.require(:photo).permit(:url, :win, :loss, :tie)
  end
end