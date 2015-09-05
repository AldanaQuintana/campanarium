class NoticesController < ApplicationController
  def show
    @notice = Notice.find(params[:id])
    respond_to do |format|
      format.json { render json: { title: @notice.title, body: @notice.body, id: @notice.id }.to_json }
    end
  end
end