class AdminController < ApplicationController

  def board
  end

  def async_response
    semantic_task = AsyncTask.find_by_id(session[:semantic_task_id])
    session.delete(:semantic_task_id) if semantic_task.nil? || semantic_task.stopped?
    sentiments = session[:sentiments_task_id]
    render json: { status: 200, semantic_status: semantic_task.try(:status), sentiments_status: sentiments}
  end

  def load_comments
    count = NoticeGroupCommentsLoader.perform
    render json: { status: 200, task_status: count > 0 ? "ok" : "stopped"}
  end
end