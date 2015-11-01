class RssSourceFetcher < SourceFetcher

  # abstract class
  # child must implement 'category_urls()'
  # child can implement 'select_rss_entries_from(rss_html)'
  # child can implement 'updated_time_from(rss_entry)'
  # child must implement 'notice_from(category, rss_entry)'

  # category_urls() debe devolver un hash cuyas keys sean
  # el nombre de la NoticeCategory y los values, urls

  def perform
    from = Time.parse options.from
    to = options.to && Time.parse(options.to) || Time.now
    fetch_noticias from, to
  end

  def fetch_noticias(from, to)
    category_urls.each do |category_name, category_url|
      category = NoticeCategory.by_name category_name
      rss_entries = fetch_rss_entries_from category_url, from, to
      rss_entries.select! do |rss_entry|
        updated_time = updated_time_from rss_entry
        updated_time && updated_time >= from && updated_time <= to
      end
      puts "#{rss_entries.count} #{source_name_from_class_name} '#{category_name}' urls found"
      rss_entries.each do |rss_entry|
        fetch_notice category, rss_entry
      end
    end
  end

  def fetch_rss_entries_from(rss_url, from, to)
    puts "Fetching #{rss_url} ..."
    rss_html = Nokogiri::HTML open rss_url
    select_rss_entries_from(rss_html).to_a
  end

  def select_rss_entries_from(rss_html)
    rss_html.css 'item'
  end

  def updated_time_from(rss_entry)
    updated_time_str = rss_entry.css('pubdate').text
    updated_time_str && Time.parse(updated_time_str)
  end

end
