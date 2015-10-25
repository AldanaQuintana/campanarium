class SentimentsAnalyzerController < ApplicationController
  def call_analyzer
    code, response = SentimentsAnalyzerConnector.analyze_comments
  end

  def response_from_analyzer
    SentimentsAnalyzerConnector.manage_response(params["_json"])
    render json: { status: 200, data: "OK"}
  end
end