class LandingController < ApplicationController
  def start
    redirect_to notice_index_path if current_user
  end
end