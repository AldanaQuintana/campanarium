class NoticeGroupCommentsLoader

  def self.perform
    NoticeGroup.without_comments.limit(10).each do |notice_group|
      NoticeGroupCommentsLoader.load_comments_for(notice_group)
    end
  end

  def self.load_comments_for(notice_group, keyword = nil)
    keyword ||= notice_group.best_keyword
    if keyword.present?
      CommentsFetcher.new.search_and_persist keyword, notice_group.id
    end
  end
end