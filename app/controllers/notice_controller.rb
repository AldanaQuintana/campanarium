class NoticeController < ApplicationController
  def index
    authorize! :noticias, :index
    # Esto debería cambiar en un futuro, no hay que traer todos los grupos
    @notice_groups = NoticeGroup.all
  end
end