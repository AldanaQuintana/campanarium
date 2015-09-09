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
    noticias_urls.each do |url|
      fetch_notice url
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

  def notice_from url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = format_title html.css('#encabezado h1').text
    body = format_body html.css '#cuerpo > p'
    image = html.css('#cuerpo .archivos-relacionados .foto img').first
    image = image && image.attr('src')
    media_items = create_media_from image
    Notice.new title: title, body: body, source: :la_nacion, url: url, media: media_items
  end

end
