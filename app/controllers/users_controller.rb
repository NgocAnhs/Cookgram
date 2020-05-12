class UsersController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:id])
    @pagy_recipes, @my_recipes = pagy(@user.recipes.order("created_at desc"), page_param: :page_recipes, params: { active_tab: 'recipes' })
    @following = @user.following
    @followers = @user.followers
    @pagy_bookmarks, @bookmarks = pagy(@user.bookmarks.order("created_at desc"), page_param: :page_bookmarks, params: { active_tab: 'bookmarks' })
  end
end
