class CategoriesController < ApplicationController
  respond_to :html, :json

  def index
    @categories = Category.all.paginate(page: params[:page], per_page: 4)
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
    @photos = @category.photos.paginate(page: params[:page], per_page: 12)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "\"#{@category.name}\" was created successfully."
    else
      if @category.errors.any?
        flash[:error] = @category.errors.full_messages.first
      else
        flash[:error] = "Something went wrong. Please try again."
      end
    end
    redirect_to :back
  end

  def update
    @category = Category.find(params[:id])
    @category.update_attributes(category_params)
    respond_with @category
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      reassign_photos(params[:id])
      flash[:notice] = "\"#{@category.name}\" was deleted successfully."
      redirect_to categories_path
    else
      flash[:error] = "Something went wrong. Please try again."
      redirect_to @category
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def reassign_photos(category_id)
    no_category = Category.find_or_create_by(name: 'No Category')
    Photo.where("category_id = ?", category_id).find_each do |photo|
      photo.update_attributes(category_id: no_category.id)
    end
  end
end