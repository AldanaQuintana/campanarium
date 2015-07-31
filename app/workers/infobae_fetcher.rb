# infobae noticias fetcher
# Casos especiales a revisar:
# (sin body) http://opinion.infobae.com/dario-epstein/2015/07/09/otra-vez-las-propiedades-al-borde-de-una-burbuja
# (body incorrecto) http://www.infobae.com/2015/07/09/1740418-la-dieta-dilma-rousseff-bajar-15-kilos-6-meses

class InfobaeFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = Time.parse options.to
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls from, to
    puts "#{noticias_urls.count} infobae urls found"
    noticias_urls.map do |url|
      notice = fetch_notice url
      # notice.save!
    end
  end

  def fetch_noticias_urls from, to
    puts 'Fetching infobae sitemap ...'
    sitemap_url = 'http://www.infobae.com/sitemap.xml'
    sitemap = Nokogiri::HTML open sitemap_url
    noticias_urls = sitemap.css('url loc').map &:text
    noticias_urls.select do |url|
      time = time_from url
      time && time >= from && time <= to
    end
  end

  def fetch_notice url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = html.css('.entry-title').first.text
    body = format_body html.css('.entry-content .cuerposmart p')
    image = html.css('.hmedia img').first
    image = image && image.attr('src')
    media_items = Array image
    # Noticia.new title: title, body: body, source: :infobae, source_url: url, media_items: media_items
    { title: title, body: body, source: :infobae, source_url: url, media_items: media_items }
  end

  def time_from url
    Time.parse url[/\d{4}\/\d{2}\/\d{2}/]
  rescue TypeError => e
    nil
  end

end
