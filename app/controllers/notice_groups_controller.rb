class NoticeGroupsController < ApplicationController

  respond_to :json, :html

  def index
    authorize! :noticias, :index
    @notice_groups = NoticeGroup.joins(:notices).page(params[:page] || 1).per(3)

    @html_partials = @notice_groups.map{|group| render_to_string partial: "notice_groups/notice_group", layout: false, formats: [:html], locals: { group: group }}
    respond_with(@notice_groups, @html_partials.join(" "))
  end

  def show
    authorize! :noticias, :show
    @notice_group = NoticeGroup.find params[:id]
  end

end