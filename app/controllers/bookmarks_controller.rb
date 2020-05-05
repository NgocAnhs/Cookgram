class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_recipe, only: [:create, :destroy]

  def create
    @bookmark = @recipe.bookmarks.new(user_id: current_user.id)
    if @bookmark.save
      @recipe = @bookmark.recipe
      respond_to :js
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    if current_user.id == @bookmark.user.id && @bookmark.destroy
      respond_to :js
    end
  end

  private

  def find_recipe
    @recipe = Recipe.friendly.find(params[:recipe_id])
  end
end
