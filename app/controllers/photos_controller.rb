class PhotosController < ApplicationController

  def show
    @photo = Photo.find(params[:id])
    @challenge = Challenge.new(challenged_id: @photo.id)
    @comments = @photo.comments
    @comment = Comment.new(photo_id: @photo.id)
    authorize @photo
  end

  def new
    @photo = Photo.new
    @categories = Category.all.pluck(:name, :id)
    @category = Category.new
    authorize @photo
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    authorize @photo
    if @photo.save
      flash[:notice] = "Your photo uploaded successfully."
      redirect_to @photo
    else
      flash[:error] = "Something went wrong. Please try again."
      render :new
    end
  end

  def edit
    @photo = Photo.find(params[:id])
    @categories = Category.all.pluck(:name, :id)
    authorize @photo
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(photo_params)
      flash[:notice] = "Your photo was updated successfully."
      redirect_to @photo
    else
      flash[:error] = "Something went wrong. Please try again."
      render :edit
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    authorize @photo
    if @photo.destroy
      flash[:notice] = "Your photo was deleted successfully."
      redirect_to @photo.user
    else
      flash[:error] = "Something went wrong. Please try again."
      redirect_to @photo
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:url, :win, :loss, :tie, :category_id, :name)
  end
end