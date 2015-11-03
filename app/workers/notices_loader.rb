class NoticesLoader < ResqueJob

  def self.perform(from = nil, to = nil)
    from = Time.parse from if from.is_a? String
    to = Time.parse to if to.is_a? String
    unless from.present? && to.present?
      to = Time.zone.now.at_beginning_of_day
      from = to - 1.day
    end
    fetchers = [CronicaFetcher, InfobaeFetcher, LaNacionFetcher, TnFetcher]
    fetchers.each do |fetcher|
      fetcher.new(from: from.to_s, to: to.to_s).perform rescue nil
    end
  end

end