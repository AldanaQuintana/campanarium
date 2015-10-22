class NoticesLoader
  def self.perform(from = nil, to = nil)
    unless from.present? && to.present?
      to = Time.zone.now
      from = to - 1.hour
    end
    fetchers = [CronicaFetcher, InfobaeFetcher, LaNacionFetcher, TnFetcher]
    fetchers.each do |fetcher|
      fetcher.new({from: from.to_s, to: to.to_s}).perform
    end
  end
end