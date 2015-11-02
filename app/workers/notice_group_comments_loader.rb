class NoticeGroupCommentsLoader

  def self.perform
    count = 0
    NoticeGroup.without_comments.with_keyword.limit(10).each do |notice_group|
      loaded = NoticeGroupCommentsLoader.load_comments_for(notice_group)
      count += 1 if loaded
    end
    count
  end

  def self.load_comments_for(notice_group, keyword = nil)
    keyword ||= notice_group.best_keyword
    if keyword.present?
      CommentsFetcher.new.search_and_persist keyword, notice_group.id
    end
    keyword.present?
  end
end