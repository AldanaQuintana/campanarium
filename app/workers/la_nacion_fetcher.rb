# lanacion noticias fetcher
# Casos especiales a revisar:
# http://personajes.lanacion.com.ar/1815218-maxi-trusso-el-cd-quedo-obsoleto-hoy-es-vinilo-y-mp3

class LaNacionFetcher < SourceFetcher

  CHANNELS = [
    { category: :politics,    url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=30'   },
    { category: :economics,   url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=272'  },
    { category: :sports,      url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=131'  },
    { category: :society,     url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=7773' },
    { category: :police,      url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=7775' },
    { category: :show,        url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=120'  },
    { category: :travel,      url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=504'  },
    { category: :tendency,    url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=1312' },
    { category: :cars,        url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=371'  },
    { category: :tecnology,   url: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=432'  }
  ]

  def perform
    from = Time.parse options.from
    to = options.to && Time.parse(options.to) || Time.now
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    CHANNELS.each do |channel|
      category_name = channel[:category]
      category = NoticeCategory.by_name category_name
      channel_url = channel[:url]
      noticias_urls = fetch_noticias_urls channel_url, from, to
      puts "#{noticias_urls.count} lanacion '#{category_name}' urls found"
      noticias_urls.each do |url|
        fetch_notice category, url
      end
    end
  end

  def fetch_noticias_urls rss_url, from, to
    puts 'Fetching lanacion rss xml ...'
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

  def notice_from category, url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = html.css('#encabezado h1').text
    body = p_body_from html.css '#cuerpo > p'
    keywords = html.css('section.en-esta-nota .tag-relacionado').map &:text
    image = html.css('#cuerpo .archivos-relacionados .foto img').first
    image = image && image.attr('src')
    create_notice title: title, categories: category, keywords: keywords,
      url: url, body: body, media: image
  end

end
