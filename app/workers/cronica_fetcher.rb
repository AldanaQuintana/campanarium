# cronica noticias fetcher

class CronicaFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = Time.parse options.to
    fetch_noticias from, to
  end
  
  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls from, to
    puts "#{noticias_urls.count} crónica urls found"
    noticias = noticias_urls.map do |url_time|
      begin
        notice = fetch_notice url_time

      rescue URI::InvalidURIError => error #Porque el sitemap tiene algunos links inaccesibles.
        
      end
      # notice.save!
    end.reject { |x| x.nil?}
    noticias
  end

  def fetch_noticias_urls from, to
    puts 'Fetching crónica sitemap ...'
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

  def fetch_notice url_time
    puts "Fetching notice in #{url_time[:url]} ..."
    html = Nokogiri::HTML open(url_time[:url]),nil,'utf-8'

    title = format_title html.css('.article-title').first.text
    body = format_body html.css('.article-text p') #En algunos artículos meten iframes en los párrafos... 
    image = html.css('.article-image img').first
    image = image && image.attr('src') #El link de las imagenes es http://static.cronica.com.ar/FileAccessHandler.ashx?code=codigo, funca igual?
    writed_at = url_time[:time] 
    media_items = create_media_from image
    Notice.create title: title, body: body, source: :cronica, url: url_time[:url], writed_at: writed_at, media: media_items
  end

  def time_from timestamp
    Time.iso8601 timestamp    #Ej: 2015-09-06T15:07:00-03:00
  rescue TypeError => e
    nil
  end

end
