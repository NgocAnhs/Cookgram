class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      @recipe = @comment.recipe
      respond_to :js
    else
      flash[:error] = 'Something went wrong!'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    # @recipe = @comment.recipe
    if current_user == @comment.user && @comment.destroy
      respond_to :js
    else
      flash[:error] = "Something went wrong!"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:recipe_id, :content, comment_images: [])
  end
end
