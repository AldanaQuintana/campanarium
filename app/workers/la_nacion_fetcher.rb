class LaNacionFetcher < RssSourceFetcher

  def category_urls
    {
      politics:  'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=30',
      economics: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=272',
      sports:    'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=131',
      society:   'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=7773',
      police:    'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=7775',
      show:      'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=120',
      travel:    'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=504',
      tendency:  'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=1312',
      cars:      'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=371',
      tecnology: 'http://contenidos.lanacion.com.ar/herramientas/rss/categoria_id=432'
    }
  end

  # override
  def rss_entries_from(rss_html)
    rss_html.css 'entry'
  end

  # override
  def updated_time_from(rss_entry)
    updated_time_str = rss_entry.css('updated').text
    updated_time_str && Time.parse(updated_time_str)
  end

  def notice_from(category, rss_entry)
    title = rss_entry.at_css('title').text
    url = rss_entry.at_css('link').attr 'href'
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    body = p_body_from html.css '#cuerpo > p'
    keywords = html.css('section.en-esta-nota .tag-relacionado').map &:text
    image = html.at_css '#cuerpo img[alt]'
    image = image && image.attr('src')
    create_notice title: title, categories: category, keywords: keywords,
      url: url, body: body, media: image
  end

end
