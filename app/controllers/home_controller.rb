class HomeController < ApplicationController
  def index
    @pagy_latest, @latest_recipes = pagy(Recipe.all.includes(:user, :likes, :comments).order("created_at desc"), page_param: :page_latest, params: { active_tab: 'lates' })
    
    if user_signed_in?
      @pagy_care, @care_recipes = pagy_array(current_user.following_and_own_recipes, page_param: :page_care, params: { active_tab: 'care' }) ## temp
    end
  end

  def preview
    # @recipe = Recipe.find(params[:id])
    @recipe = Recipe.friendly.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search
    @parameter = params[:search].downcase
    @pagy, @results = pagy(Recipe.where("title LIKE ?", "%" + @parameter + "%"))
  end
end
