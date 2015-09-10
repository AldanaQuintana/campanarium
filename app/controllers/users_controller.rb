class UsersController < ApplicationController
  respond_to :json, :html

  before_filter :authenticate_admin_user!, only: [:destroy]

  def index
    authorize! :users, :index
    if current_user.admin?
      @users = User.name_like(params[:name_cont]).order(:name).page(params[:page] || 1).per(10)
    else
      @users = User.name_like(params[:name_cont]).order(:name).where("destroyed_at is null").page(params[:page] || 1).per(10)
    end
    @html_partial = @users.map{|user| render_to_string partial: "users/user", layout: false, formats: [:html], locals: { user: user, index: @users.index(user), users_length: @users.length }}.join("")
    respond_with(@users, @html_partial)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroyed_at = Time.zone.now
    @user.reasons_of_destroying = params[:reasons]
    @user.save

    UserMailer.user_banned_email(@user).deliver

    respond_with(@user)
  end
end