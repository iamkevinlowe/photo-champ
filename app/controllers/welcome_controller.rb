class WelcomeController < ApplicationController
  def index
    @top_photos = Photo.top_photos(4)
  end
end
