class UsersController < ApplicationController
  def index
    @users = User.order(:name).page(params[:page] || 1).per(10)
  end
end