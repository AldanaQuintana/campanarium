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
      updated_time = notice[:updated_time]
      belongs_to_interval = updated_time && updated_time >= from && updated_time <= to
      # notice.save! if belongs_to_interval
      notice
    end.compact
  end

  def fetch_noticias_urls
    puts 'Fetching minutouno sitemap ...'
    sitemap_url = 'http://www.minutouno.com/sitemap.xml'
    sitemap = Nokogiri::HTML open sitemap_url
    sitemap.css('url loc').map &:text
  end

  def fetch_notice url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = html.css('.article-detail-heading .title').text
    body = format_body html.css '.article-content > div'
    image = html.css('.gallery-area img').first
    image = image && image.attr('src')
    media_items = Array image
    updated_time_str = html.css('.article-detail-heading .date').text.gsub 'de', '' # Formato: '31 de julio 2015 - 18:29'
    updated_time = updated_time_str && Time.parse(updated_time_str)
    puts "Updated time text: '#{updated_time_str}' Updated time parsed: #{updated_time}"
    { title: title, body: body, source: :minuto_uno, source_url: url, media_items: media_items, updated_time: updated_time }
  end

end
