class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end


  def unlink_provider
    current_user.unlink_provider(params[:provider])
    redirect_to edit_user_registration_path
  end


end

