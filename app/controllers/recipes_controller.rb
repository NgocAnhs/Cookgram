class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe, only: [:edit, :update, :show, :destroy]
  before_action :process_image, only: [:create]

  def show
    if current_user != @recipe.user || @recipe.published
      redirect_to root_path
    else
      # save log recipe was viewd by current user
      exist = ViewedRecipe.find_by(user_id: current_user.id, recipe_id: @recipe.id).present?
      ViewedRecipe.create(user_id: current_user.id, recipe_id: @recipe.id) unless exist
    end
  end
  
  def new
    @recipe = Recipe.new
    @recipe.ingredients.new
    @recipe.steps.new
  end
  
  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      current_user.followers.each do |follower|
        Notification.create(user_id: follower.id, actor_id: current_user.id, action: "posted", notifiable: @recipe)
      end
      flash[:success] = t('controllers.recipes.create_success')
      redirect_to @recipe
    else
      flash[:error] = "Something went wrong"
      redirect_to root_path
    end
  end

  def edit
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
    image.gravity "Center"
    x = image.width > 720 ? (image.width - 720) / 2 : 0
    y = image.height > 540 ? (image.height - 540) / 2 : 0
    image.crop "720x540+#{x}+#{y}"
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
