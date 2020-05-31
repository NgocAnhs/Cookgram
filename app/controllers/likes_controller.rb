class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action -> {type_subject?(params)}

  def create
    return unless @subject
    @like = @subject.likes.new(user_id: current_user.id)
    if @like.save
      current_user.notifications.create(action: "liked", notifiable: @subject) unless current_user == @subject.user
      respond_to :js
    end
  end

  def destroy
    @like = Like.find(params[:id])
    if current_user == @like.user && @like.destroy
      respond_to :js
    end
  end

  private

  def type_subject?(params)
    if params.key?('recipe_id')
      @subject = Recipe.friendly.find(params[:recipe_id])
      @type = 'recipe'
    end

    if params.key?('comment_id')
      @subject = Comment.find(params[:comment_id])
      @type = 'comment'
    end
  end
end
