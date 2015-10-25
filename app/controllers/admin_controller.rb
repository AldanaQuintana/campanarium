class AdminController < ApplicationController

  def board
  end

  def async_response
    flash[:alert] = session[:alert]
    flash[:error] = session[:error]
  end
end