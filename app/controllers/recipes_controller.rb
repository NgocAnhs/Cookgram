class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :search]
  before_action :set_recipe, only: [:edit, :update, :show, :destroy]
  before_action :process_image, only: [:create]

  def index
    @pagy_latest, @latest_recipes = pagy(Recipe.all.includes(:user, :likes, :comments).order("created_at desc"), page_param: :page_latest, params: { active_tab: 'lates' })
    
    if user_signed_in?
      @pagy_care, @care_recipes = pagy_array(current_user.following_and_own_recipes, page_param: :page_care, params: { active_tab: 'care' }) ## temp
    end
  end
  
  def show
  end
  
  def search
    @parameter = params[:search].downcase
    @pagy, @results = pagy(Recipe.where("title LIKE ?", "%" + @parameter + "%"))
  end

  def new
    @recipe = Recipe.new
    @recipe.ingredients.new
    @recipe.steps.new
  end
  
  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      flash[:success] = t('controllers.recipes.create_success')
      redirect_to root_path
    else
      flash[:error] = "Something went wrong"
      redirect_to root_path
    end
  end

  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Cập nhật công thức thành công!"
      redirect_to recipe_path(@recipe)
    else
      flash[:error] = "Cập nhật thất bại"
      render "edit"
    end
  end

  def destroy
    if @recipe.user == current_user
      if @recipe.destroy
        flash[:success] = "Successfully"
      else
        flash[:error] = "Failed"
      end
      redirect_to root_path
    end
  end
  
  private

  def set_recipe
    @recipe = Recipe.friendly.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(
      :title, :image,
      ingredients_attributes: [:id, :name, :_destroy],
      steps_attributes: [:id, :content, {step_images: []}, :_destroy])
  end

  def optimized_image img
    return unless img
    image = MiniMagick::Image.new(img.tempfile.path)
    image.strip
    image.resize "720x540^"
  end

  def process_image
    threads = []
    threads << Thread.new { optimized_image params[:recipe][:image] }
    params[:recipe][:steps_attributes].each do |step|
      step[1][:step_images]&.each do |img|
        threads << Thread.new { optimized_image img}
      end
    end
    threads.each(&:join)
  end

end
