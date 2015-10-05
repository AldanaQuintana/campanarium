class SemanticAnalyzerController < ApplicationController
  def response_from_analyzer
    SemanticAnalyzerConnector.manage_response(params, params["error"].present? ? 500 : 200)
    render json: { status: 200, data: "OK"}
  end
end