class SemanticAnalyzerConnector
  class << self
    def group_notices
      body = {
        corpus: [],
        metadata: {}
      }
      notices = Notice.where(notice_group_id: nil)
      notices.each do |notice|
        body[:corpus].push({
          document: notice.body,
          category: notice.categories[0],
          keywords: notice.keywords,
          user_info: notice.id
        })
      end

      body[:metadata][:nmb_of_centroids] = (notices.length / notices.pluck(:source).uniq.count).to_i
      from = Time.now
      code, response = ExternalServiceCall.new().post(url("/analyzer"), body)
      duration = Time.now - from
      puts("Duración: #{duration}")
      if(code == 200){
        response["result_set"]["result"].each do |result|
          NoticeGroup.create(notices: Notice.find(result["grouped_documents"].map{|document| document["user_info"]}))
        end
      }
    end

    def url(route)
      "http://#{AppConfiguration.configuration[:semantic_analyzer_host]}:#{AppConfiguration.configuration[:semantic_analyzer_port]}/#{route}"
    end
  end
end