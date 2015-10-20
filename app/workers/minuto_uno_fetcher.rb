# minutouno noticias fetcher
# Cosas a revisar:
# Las imagenes parecen cargarse via js
# El body de http://www.minutouno.com/notas/1281464-titi-fernandez-todas-las-noches-revivo-el-dia-que-me-entere-la-muerte-sole

class MinutoUnoFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = Time.parse options.to
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls
    puts "#{noticias_urls.count} minuto uno urls found"
    belongs_to_interval = true
    noticias_urls.map do |url|
      next nil unless belongs_to_interval
      notice = fetch_notice url
      next unless notice
      updated_time = notice.writed_at
      belongs_to_interval = updated_time && updated_time >= from && updated_time <= to
    end
  end

  def fetch_noticias_urls
    puts 'Fetching minutouno sitemap ...'
    sitemap_url = 'http://www.minutouno.com/sitemap.xml'
    sitemap = Nokogiri::HTML open sitemap_url
    sitemap.css('url loc').map &:text
  end

  def notice_from url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = html.css('.article-detail-heading .title').text
    body = p_body_from html.css '.article-content'
    # categories = html.css 'section.article-detail-heading .tag.one-line'
    keywords = html.css('section.extra-tag-list .tag-list .link').map &:text
    image = html.css('.gallery-area img').first
    image = image && image.attr('src')
    writed_at_str = html.css('.article-detail-heading .date').text.gsub 'de', '' # Formato: '31 de julio 2015 - 18:29'
    writed_at = writed_at_str && Time.parse(writed_at_str)
    puts "Updated time text: '#{writed_at_str}' Updated time parsed: #{writed_at}"
    create_notice title: title, keywords: keywords,
      url: url, writed_at: writed_at, body: body, media: image
  end

end
