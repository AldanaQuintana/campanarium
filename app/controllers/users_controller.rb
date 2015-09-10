class UsersController < ApplicationController
  respond_to :json, :html

  before_filter :authenticate_admin_user!, only: [:destroy]

  def index
    authorize! :users, :index
    if current_user.admin?
      @users = User.order(:name).page(params[:page] || 1).per(10)
    else
      @users = User.order(:name).where("destroyed_at is null").page(params[:page] || 1).per(10)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroyed_at = Time.zone.now
    @user.save

    respond_with(@user)
  end
end