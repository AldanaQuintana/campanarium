# cronica noticias fetcher

class CronicaFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = Time.parse options.to
    fetch_noticias from, to
  end
  
  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls from, to
    puts "#{noticias_urls.count} cronica urls found"
    noticias = noticias_urls.each do |url_time|
      # begin
        notice = fetch_notice url_time

      # rescue URI::InvalidURIError => error #Porque el sitemap tiene algunos links inaccesibles.
        
      # end
      # notice.save!
    end
    # end.reject { |x| x.nil?}
    # noticias
  end

  def fetch_noticias_urls from, to
    puts 'Fetching cronica sitemap ...'
    sitemap_url = 'http://www.cronica.com.ar/sitemap.xml'
    sitemap = Nokogiri::HTML open sitemap_url
    urls_data = sitemap.css('url').map do |data|
      time = time_from data.css("news publication_date").text 
      {url: data.css('loc').text, time: time}
    end
    urls_data.select do |data|
      data[:time] && data[:time] >= from && data[:time] <= to
    end
  end

  def notice_from data
    url = data[:url]
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open(url),nil,'utf-8'
    title = format_title html.css('.article-title').first.text
    body = format_body html.css('.article-text p') #En algunos artículos meten iframes en los parrafos...
    keywords = format_keywords html.css('.article-tags a').map(&:text)
    keywords = keywords*','
    image = html.css('.article-image img').first
    image = image && image.attr('src') #El link de las imagenes es http://static.cronica.com.ar/FileAccessHandler.ashx?code=codigo, funca igual?
    writed_at = data[:time] 
    media_items = create_media_from image
    Notice.new title: title, body: body, keywords: keywords, source: :cronica, url: url, writed_at: writed_at, media: media_items
  end

  def time_from timestamp
    Time.iso8601 timestamp #Ej: 2015-09-06T15:07:00-03:00
  rescue TypeError
    nil
  end

end
