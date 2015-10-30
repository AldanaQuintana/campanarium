class SentimentsAnalyzerConnector
  class << self
    def analyze_comments(task_id = '')
      opts = {
        sentences: [],
        respond_to: "#{AppConfiguration.sentiments_analyzer_response_url}?task_id=#{task_id}",
        classifier: "redis"
      }

      comments = Comment.where(polarity: nil).limit(100)
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
      return [code, response]
    end

    def manage_response(results, status = nil)
      results.each do |result|
        comment = Comment.find_by_id result["user_info"]
        if comment.present?
          comment.set_polarity(result["result"])
        end
      end
    end

    def url(route)
      "http://#{AppConfiguration.configuration[:sentiments_analyzer_host]}:#{AppConfiguration.configuration[:sentiments_analyzer_port]}/#{route}"
    end
  end
end