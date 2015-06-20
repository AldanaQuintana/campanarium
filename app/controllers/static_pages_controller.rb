class StaticPagesController < ApplicationController
  before_filter :set_static_page

  def show
  end

  def edit
  end

  def set_static_page
    @static_page = StaticPage.find_by_param_name(params[:id])
  end
end