# lanacion noticias fetcher
# Casos especiales a revisar:
# http://personajes.lanacion.com.ar/1815218-maxi-trusso-el-cd-quedo-obsoleto-hoy-es-vinilo-y-mp3

class LaNacionFetcher < SourceFetcher

  CHANNELS = [
    { name: 'politica', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=30' },
    { name: 'economia', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=272' },
    { name: 'deportes', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=131' },
    { name: 'sociedad', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=7773' },
    { name: 'seguridad', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=7775' },
    { name: 'espectaculos', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=120' },
    { name: 'turismo', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=504' },
    { name: 'moda', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=1312' },
    { name: 'autos', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=371' },
    { name: 'tecnologia', url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=432' }
  ]

  def perform
    from = Time.parse options.from
    to = options.to && Time.parse(options.to) || Time.now
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    CHANNELS.each do |channel|
      channel_name = channel[:name]
      channel_url = channel[:url]
      noticias_urls = fetch_noticias_urls channel_url, from, to
      puts "#{noticias_urls.count} lanacion '#{channel_name}' urls found"
      noticias_urls.each do |url|
        fetch_notice channel_name, url
      end
    end
  end

  def fetch_noticias_urls rss_url, from, to
    puts 'Fetching lanacion rss xml ...'
    # rss_url = 'http://contenidos.lanacion.com.ar/herramientas/rss/origen=2'
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

  def notice_from channel_name, url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = format_title html.css('#encabezado h1').text
    body = format_p_body html.css '#cuerpo > p'
    categories = format_keywords channel_name
    keywords = format_keywords html.css('section.en-esta-nota .tag-relacionado').map &:text
    image = html.css('#cuerpo .archivos-relacionados .foto img').first
    image = image && image.attr('src')
    media_items = create_media_from image
    Notice.new title: title, body: body, keywords: keywords, categories: categories,
      source: :la_nacion, url: url, media: media_items
  end

end
