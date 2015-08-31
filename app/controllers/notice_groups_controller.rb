class NoticeGroupsController < ApplicationController

  def index
    authorize! :noticias, :index
    # Esto debería cambiar en un futuro, no hay que traer todos los grupos
    @notice_groups = NoticeGroup.all
  end

  def show
    authorize! :noticias, :show
    @notice_group = NoticeGroup.find params[:id]
  end

end