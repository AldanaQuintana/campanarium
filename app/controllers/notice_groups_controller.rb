class NoticeGroupsController < ApplicationController

  respond_to :json, :html

  def index
    authorize! :noticias, :index
    @notice_groups = NoticeGroup.joins(:notices).page(params[:page] || 1).per(3)
    respond_with(@notice_groups)
  end

  def show
    authorize! :noticias, :show
    @notice_group = NoticeGroup.find params[:id]
  end

end