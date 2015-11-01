class PerfilFetcher < RssSourceFetcher

  def category_urls
    {
      politics:  'http://www.perfil.com/rss/politica.xml',
      economics: 'http://www.perfil.com/rss/economia.xml',
      police:    'http://www.perfil.com/rss/policia.xml',
      sports:    'http://www.perfil.com/rss/deportes.xml',
      society:   'http://www.perfil.com/rss/sociedad.xml',
      show:      'http://www.perfil.com/rss/espectaculos.xml',
      health:    'http://www.perfil.com/rss/salud.xml',
      tecnology: 'http://www.perfil.com/rss/tecnologia.xml'
    }
  end

  # override
  def rss_entries_from(rss_html)
    rss_html.css 'channel > item'
  end

  def notice_from(category, rss_entry)
    title = rss_entry.css('title').text
    # url = rss_entry.css('link').text
    url = rss_entry.text.match('http\:\/\/.*\n').to_s.gsub("\n", '')
    return unless url.include? 'perfil.com'
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    possible_body = html.css '[itemprop=articleBody] p'
    body = if possible_body.empty?
      # algunas notas de perfil tienen body plano
      html.css('[itemprop=articleBody]').text
    else
      # otras tienen "p-body"
      p_body_from html.css '[itemprop=articleBody] p'
    end 
    keywords = html.css('#tagsNota [itemprop=keywords]').map &:text
    image = rss_entry.at_css 'enclosure'
    image = image && image.attr('url')
    create_notice title: title, categories: category, keywords: keywords,
      url: url, body: body, media: image
  end

end
