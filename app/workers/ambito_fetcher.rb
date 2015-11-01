class AmbitoFetcher < RssSourceFetcher

  def category_urls
    {
      economics: 'http://www.ambito.com/rss/noticias.asp?s=Econom%EDa',
      politics:  'http://www.ambito.com/rss/noticias.asp?s=Pol%EDtica',
      sports:    'http://www.ambito.com/rss/noticias.asp?s=Deportes',
      show:      'http://www.ambito.com/rss/noticias.asp?s=Espect%E1culos',
      tecnology: 'http://www.ambito.com/rss/noticias.asp?s=Tecnolog%EDa',
      cars:      'http://www.ambito.com/rss/suplementos.asp?s=Panorama%20Automotor',
      rugby:     'http://www.ambito.com/rss/suplementos.asp?s=Rugby'
    }
  end

  def notice_from(category, rss_entry)
    title = rss_entry.at_css('title').text
    # url = rss_entry.css('link').text
    url = rss_entry.text.match('http\:\/\/.*\n').to_s.gsub("\n", '')
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    body = html.css('#textoDespliegue').text
    keywords = html.css('#tags a').map &:text
    image = html.at_css '#imgDesp'
    image = image && image.attr('src')
    create_notice title: title, categories: category, keywords: keywords,
      url: url, body: body, media: image
  end

end
