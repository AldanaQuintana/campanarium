class StaticPagesController < ApplicationController
  before_filter :set_static_page
  before_filter :authenticate_admin_user!, only: [:mercury_update]

  helper_method :editing?

  def show
    redirect_to root_path unless @static_page
  end

  def update
    @static_page.title = params[:content][:page_title][:value]
    @static_page.main_content = params[:content][:page_main_content][:value]
    @static_page.save!
    render json: {url: static_page_path(id: @static_page.to_param)}
  end

  def set_static_page
    @static_page = StaticPage.find_by_param_name(params[:id])
  end

  def editing?
    request.path.index("/editor/") == 0
  end
end