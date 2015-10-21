class SentimentsAnalyzerConnector
  class << self
    def analyze_comments
      opts = {
        sentences: [],
        respond_to: AppConfiguration.sentiments_analyzer_response_url,
        classifier: "mongo"
      }

      comments = Comment.where(positive: nil).limit(100)
      comments.each do |comment|
        opts[:sentences].push({
          text: comment.message,
          user_info: comment.id
        })
      end
      puts opts
      code, response = ExternalServiceCall.new().post(url("analyse"), opts)
      if(code == 200)
        puts("Request success")
      else
        puts("Request failed: #{response['error']}" ) if response
      end
    end

    def manage_response(response, status = nil)
      puts response
    end

    def url(route)
      "http://#{AppConfiguration.configuration[:sentiments_analyzer_host]}:#{AppConfiguration.configuration[:sentiments_analyzer_port]}/#{route}"
    end
  end
end