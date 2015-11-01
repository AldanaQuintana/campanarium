class InfoNewsFetcher < RssSourceFetcher

  def category_urls
    # se obvia la categoria 'Mundo'
    {
      politics:  'http://www.infonews.com/rss/politica.xml',
      economics: 'http://www.infonews.com/rss/economia.xml',
      society:   'http://www.infonews.com/rss/sociedad.xml',
      sports:    'http://www.infonews.com/rss/deportes.xml',
      show:      'http://www.infonews.com/rss/espectaculos.xml'
    }
  end

  def notice_from(category, rss_entry)
    title = rss_entry.css('title').text
    # url = rss_entry.css('link').text
    url = rss_entry.text.match('http\:\/\/.*\n').to_s.gsub("\n", '')
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    body = p_body_from html.css '.article-body p'
    # infonews no muestra keywords
    image = rss_entry.at_css 'enclosure'
    image = image && image.attr('url')
    create_notice title: title, categories: category,
      url: url, body: body, media: image
  end

end
