require "requests/sugar"

class ExternalServiceCall
  class ExternalServiceCallError < StandardError; end
  def post(url, data={})
    response = Requests.post(url, data: data.to_json, headers: {"Content-type" => "application/json"})

    [response.status, JSON.parse(response.body)]

  rescue Requests::Error => e
    case e.response.code.to_i
    when 500
      raise ExternalServiceCallError.new("There was an error with the external call to #{url} with #{data}")
    when 422
      [e.response.code.to_i, e.response.body.present? ? JSON.parse(e.response.body) : ""]
    end

  end
end