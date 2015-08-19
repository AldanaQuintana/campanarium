class NoticiasController < ApplicationController
  def index
    authorize! :noticias, :index
  end
end