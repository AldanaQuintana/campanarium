class SemanticAnalyzerController < ApplicationController
  def call_analyzer
    task = nil
    begin
      task = AsyncTask.create(status: "running", name: "semantic")
      session[:semantic_task_id] = task.id
      code, response = SemanticAnalyzerConnector.group_notices(task.id)
      task.update_attributes(status: "stopped") if code.nil? && response.nil?
      render json: {status: code, response: response, analyzer_status: task.status }
    rescue => e
      if task.present?
        task.update_attributes(status: "stopped")
      else
        task = AsyncTask.create(status: "stopped", name: "semantic")
      end
      session[:semantic_task_id] = task.id
      throw e
    end
  end

  def response_from_analyzer
    task = AsyncTask.find_by_id(params["task_id"])
    begin
      SemanticAnalyzerConnector.manage_response(params, params["error"].present? ? 500 : 200)
      if task.present?
        if params["error"].present?
          task.update_attributes(status: "failure")
        else
          task.update_attributes(status: "finished")
        end
      end
      render json: { status: 200, data: "OK"}
    rescue => e
      task.update_attributes(status: "failure") if task.present?
      throw e
    end
  end
end