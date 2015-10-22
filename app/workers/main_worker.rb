class MainWorker
  def self.perform(skip_notices = false, skip_comments = false)
    NoticesLoader.perform unless skip_notices
    SemanticAnalyzerConnector.group_notices
    NoticeGroupCommentsLoader.perform unless skip_comments
    SentimentsAnalyzerConnector.analyze_comments
  end
end