class AdminController < ApplicationController

  def board
  end

  def async_response
    semantic_task = AsyncTask.find_by_id(session[:semantic_task_id])
    session.delete(:semantic_task_id) if semantic_task.nil? || semantic_task.stopped?
    sentiments_task = AsyncTask.find_by_id(session[:sentiments_task_id])
    session.delete(:sentiments_task_id) if sentiments_task.nil? || sentiments_task.stopped?
    render json: { status: 200, semantic_status: semantic_task.try(:status), sentiments_status: sentiments_task.try(:status)}
  end

  def load_comments
    count = NoticeGroupCommentsLoader.perform
    render json: { status: 200, task_status: count > 0 ? "ok" : "stopped"}
  end

  def load_notices
    begin
      to = Time.zone.now
      window = params[:hours] || 1
      from = to - window.to_i.hours
      # job_id = Resque.enqueue NoticesLoader, from, to
      # job_id = NoticesLoader.create from: from, to: to
      job_id = JobWrapper.create class: 'NoticesLoader', from: from, to: to
      render json: { status: 200, task_status: "ok", job_id: job_id }
    rescue => e
      render json: { status: 500, task_status: "failure", message: "Hubo un error cargando las noticias." }
      throw e
    end
  end

  def job_status
    job_id = params[:job_id]
    status = Resque::Plugins::Status::Hash.get job_id
    render json: { working: status.working? }
  end

end