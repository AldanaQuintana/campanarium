class SemanticAnalyzerController < ApplicationController
  def response
    SemanticAnalyzerConnector.manage_response(params, params["error"].present? ? 500 : 200)
  end
end