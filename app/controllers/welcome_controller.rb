class WelcomeController < ApplicationController
  def index
    Challenge.send_results
    @top_photos = Photo.top_photos(4)
  end
end
