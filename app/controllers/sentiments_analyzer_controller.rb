class SentimentsAnalyzerController < ApplicationController
  def response_from_analyzer
    SentimentsAnalyzerConnector.manage_response(params)
    render json: { status: 200, data: "OK"}
  end
end