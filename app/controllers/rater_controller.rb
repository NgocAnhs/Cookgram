class RaterController < ApplicationController

  def create
    if user_signed_in?
      obj = params[:klass].classify.constantize.friendly.find(params[:id])
      obj.rate params[:score].to_f, current_user, params[:dimension]

      user = obj.user
      num = Rate.all.where(rateable: user.recipes, stars: (3..5)).size
      user.update_attributes(trusted: true) if num > 3
      render :json => true
    else
      render :json => false
    end
  end
end
