class SentimentsAnalyzerController < ApplicationController
  def call_analyzer
    task = nil
    begin
      task = AsyncTask.create(status: "running", name: "sentiments")
      session[:sentiments_task_id] = task.id
      code, response = SentimentsAnalyzerConnector.analyze_comments(session[:sentiments_task_id])
      task.update_attributes(status: "stopped") if code.nil? && response.nil?
      render json: {status: code, response: response, analyzer_status: task.status }
    rescue => e
      if task.present?
        task.update_attributes(status: "stopped")
      else
        task = AsyncTask.create(status: "stopped", name: "semantic")
      end
      session[:sentiments_task_id] = task.id
      throw e
    end
  end

  def response_from_analyzer
    begin
      task = AsyncTask.find_by_id(params["task_id"])
      SentimentsAnalyzerConnector.manage_response(params["_json"])
      task.update_attributes(status: "finished") if task.present?
      render json: { status: 200, data: "OK"}
    rescue => e
      task.update_attributes(status: "failure") if task.present?
      throw e
    end
  end
end