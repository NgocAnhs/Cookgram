class HomeController < ApplicationController
  def index
    @pagy_latest, @latest_recipes = pagy_countless(Recipe.all.published.includes(:user, :likes, :comments).order("created_at desc"), page_param: :page_latest, params: { active_tab: 'lates' }, link_extra: 'data-remote="true"')
    @master_chefs = find_master_chefs
    if user_signed_in?
      @recommend_recipes = current_user.recommend_recipes.collect { |val| val[0].recipe if val[0].recipe.published }.compact.uniq.shuffle.take(4)
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
    # @parameter = params[:search].downcase
    if params[:search].nil?
      @results = []
    else
      @pagy, @results = pagy(Recipe.search params[:search])
    end
    # @pagy, @results = pagy(Recipe.where("title LIKE ?", "%" + @parameter + "%"))
  end

  private

  def find_master_chefs
    rela = Relationship.group(:followed_id).count.sort_by{|k,v| v}.reverse.take(6)
    users = []
    rela.each do |r| 
      users << User.find_by(id: r[0]) 
    end
    users
  end
end
