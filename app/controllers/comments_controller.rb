class CommentsController < ApplicationController

  def create
    photo = Photo.find(params[:photo_id])
    @comment = current_user.comments.build(comment_params)
    @comment.photo_id = photo.id
    @new_comment = Comment.new(photo_id: photo.id)
    authorize @comment
    if @comment.save
      flash[:notice] = "Comment created successfully."
    else
      flash[:error] = "Something went wrong. Please try again."
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.destroy
      flash[:notice] = "Comment was deleted successfully."
    else
      flash[:error] = "Something went wrong. Please try again."
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end