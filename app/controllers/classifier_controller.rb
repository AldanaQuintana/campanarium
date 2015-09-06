class ClassifierController < ApplicationController
  def clasify
    @notices_ids = Notice.pluck(:id)
  end

  def related
    @notice = Notice.find(params[:main])
    @notice.related_notices.push(*params[:related])
    @notice.related_notices.uniq!
    @notice.save
    respond_to do |format|
      format.json{ render json: {}, status: 200 }
    end
  end
end