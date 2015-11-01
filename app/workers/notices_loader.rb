class NoticesLoader
  def self.perform(from = nil, to = nil)
    unless from.present? && to.present?
      to = Time.zone.now.at_beginning_of_day
      from = to - 1.day
    end
    fetchers = [CronicaFetcher, InfobaeFetcher, LaNacionFetcher, TnFetcher, PaginaDoceFetcher, InfoNewsFetcher, AmbitoFetcher, PerfilFetcher]
    fetchers.each do |fetcher|
      begin
        fetcher.new({from: from.to_s, to: to.to_s}).perform
      rescue => e
      end
    end
  end
end