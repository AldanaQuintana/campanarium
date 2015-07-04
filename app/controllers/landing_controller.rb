class LandingController < ApplicationController
  def start
    redirect_to noticias_path if current_user
  end
end