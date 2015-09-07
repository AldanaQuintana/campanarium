class NoticesController < ApplicationController
  before_filter :authenticate_admin_user!
  before_filter :set_notice
  respond_to :json

  def destroy
    @notice.destroy
    respond_with(@notice)
  end

  def unlink
    @notice.unlink!
    respond_with(@notice)
  end

  private
    def set_notice
      @notice = Notice.find(params[:id])
    end
end