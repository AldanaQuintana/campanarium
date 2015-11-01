class PaginaDoceFetcher < RssSourceFetcher

  def category_urls
    {
      sports:    'http://www.pagina12.com.ar/diario/rss/libero.xml',
      economics: 'http://www.pagina12.com.ar/diario/rss/cash.xml',
      travel:    'http://www.pagina12.com.ar/diario/rss/turismo.xml',
      show:      'http://www.pagina12.com.ar/diario/rss/espectaculos.xml'
    }
  end

  def notice_from(category, rss_entry)
    title = rss_entry.css('title').text
    # url = rss_entry.css('link').text
    url = rss_entry.text.match('http\:\/\/.*\n').to_s.gsub("\n", '')
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    body = p_body_from html.css '#cuerpo p'
    # pagina12 no muestra keywords
    image = html.at_css '.foto_nota img'
    image = image && image.attr('src')
    create_notice title: title, categories: category,
      url: url, body: body, media: image
  end

end
