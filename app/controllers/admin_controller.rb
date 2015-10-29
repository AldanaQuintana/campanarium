class AdminController < ApplicationController

  def board
  end

  def async_response
    semantic_task = AsyncTask.find_by_id(session[:semantic_task_id])
    sentiments = session[:sentiments_task_id]
    render json: { status: 200, semantic_status: semantic_task.status, sentiments_status: sentiments}
  end
end