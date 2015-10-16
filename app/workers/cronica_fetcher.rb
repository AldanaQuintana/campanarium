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
      fetch_notice url_time
    end
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
    title = html.css('.article-title').first.text
    # En algunos artículos meten iframes en los parrafos...
    body = p_body_from html.css '.article-text p'
    keywords = html.css('.article-tags a').map &:text
    categories = html.css('.article-section').text
    image = html.css('.article-image img').first
    # El link de las imagenes es http://static.cronica.com.ar/FileAccessHandler.ashx?code=codigo, funca igual?
    image = image && image.attr('src')
    writed_at = data[:time]
    create_notice title: title, categories: categories, keywords: keywords,
      url: url, body: body, writed_at: writed_at, media: image
  end

  def time_from timestamp
    Time.iso8601 timestamp #Ej: 2015-09-06T15:07:00-03:00
  rescue TypeError
    nil
  end

end
