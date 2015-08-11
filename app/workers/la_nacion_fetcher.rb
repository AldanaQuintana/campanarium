# lanacion noticias fetcher
# Casos especiales a revisar:
# http://personajes.lanacion.com.ar/1815218-maxi-trusso-el-cd-quedo-obsoleto-hoy-es-vinilo-y-mp3

class LaNacionFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = options.to && Time.parse(options.to) || Time.now
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls from, to
    puts "#{noticias_urls.count} lanacion urls found"
    noticias_urls.map do |url|
      notice = fetch_notice url
      # notice.save!
    end
  end

  def fetch_noticias_urls from, to
    puts 'Fetching lanacion rss xml ...'
    rss_url = 'http://contenidos.lanacion.com.ar/herramientas/rss/origen=2'
    rss = Nokogiri::HTML open rss_url
    noticias_data = rss.css('feed entry').to_a
    noticias_data.select! do |data|
      updated_time = data.css('updated').text
      updated_time = updated_time && Time.parse(updated_time)
      updated_time && updated_time >= from && updated_time <= to
    end
    noticias_data.map do |data|
      data.css('link').attr('href').text
    end
  end

  def fetch_notice url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = html.css('#encabezado h1').text
    body = format_body html.css '#cuerpo > p'
    image = html.css('#cuerpo .archivos-relacionados .foto img').first
    image = image && image.attr('src')
    media_items = Array image
    { title: title, body: body, source: :la_nacion, source_url: url, media_items: media_items }
  end

end
