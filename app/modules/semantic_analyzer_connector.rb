class SemanticAnalyzerConnector
  class << self
    def group_notices
      # body = {
      #   corpus: [],
      #   metadata: {
      #   nmb_of_centroids: 2
      #   }
      # }

      notice = Notice.first
      body = {
        corpus: [
          {
            document: notice.body,
            category: notice.categories[0],
            keywords: notice.keywords,
            user_info: notice.id
          },
          { document: "foo2", category: "politics", keywords: ["foo"], user_info: "user_info_1" }
        ],
        metadata: {
          nmb_of_centroids: 2
        }
      }

      ExternalServiceCall.new().post(url("/analyzer"), body)
    end

    def url(route)
      "http://#{AppConfiguration.configuration[:semantic_analyzer_host]}:#{AppConfiguration.configuration[:semantic_analyzer_port]}/#{route}"
    end
  end
end