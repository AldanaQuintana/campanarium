class StaticPagesController < ApplicationController
  before_filter :set_static_page
  before_filter :authenticate_admin_user!, only: [:update]
  before_filter :check_can_edit, only: [:show]

  helper_method :editing?

  def show
    redirect_to root_path unless @static_page
  end

  def update
    current_user.present? && current_user.admin? and
    @static_page.title = params[:content][:page_title][:value]
    @static_page.main_content = params[:content][:page_main_content][:value]
    @static_page.save!
    render json: {url: static_page_path(id: @static_page.to_param)}
  end

  def set_static_page
    @static_page = StaticPage.find_by_param_name(params[:id])
  end

  def editing?
    request.path.index("/editor/") == 0 || params[:editing]
  end

  def check_can_edit
    authenticate_admin_user! if editing?
  end
end