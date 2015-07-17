class PhotosController < ApplicationController

  private

  def photo_params
    params.require(:photo).permit(:url, :win, :loss, :tie)
  end
end