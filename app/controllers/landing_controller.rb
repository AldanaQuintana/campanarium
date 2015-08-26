class LandingController < ApplicationController
  def start
    redirect_to notice_groups_path if current_user
  end
end