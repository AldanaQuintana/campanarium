class NoticeController < ApplicationController
  def index
    authorize! :noticias, :index
  end
end