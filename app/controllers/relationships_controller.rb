class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
  
  def create
    current_user.follow(@user)
    respond_to :js
  end

  def destroy
    current_user.unfollow(@user)
    respond_to :js
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
