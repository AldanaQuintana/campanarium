class SemanticAnalyzerController < ApplicationController
  def call_analyzer
    code, response = SemanticAnalyzerConnector.group_notices
  end

  def response_from_analyzer
    SemanticAnalyzerConnector.manage_response(params, params["error"].present? ? 500 : 200)
    render json: { status: 200, data: "OK"}
  end
end