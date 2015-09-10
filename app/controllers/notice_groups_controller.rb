class NoticeGroupsController < ApplicationController

  respond_to :json, :html

  def index
    authorize! :noticias, :index
    @page = params[:page] || 1
    @notice_groups = NoticeGroup.order("created_at").joins(:notices).uniq.page(@page).per(3)

    @html_partials = @notice_groups.map{|group| render_to_string partial: "notice_groups/notice_group", layout: false, formats: [:html], locals: { group: group }}
    respond_with(@notice_groups, @html_partials.join(" "))
  end

  def show
    authorize! :noticias, :show
    @notice_group = NoticeGroup.find params[:id]
  end

end