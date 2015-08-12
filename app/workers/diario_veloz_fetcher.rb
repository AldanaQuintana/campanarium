# diario veloz noticias fetcher
# Cosas a revisar:
# Newlines en el body (no usan nodos <div> o <p> como los otros...)

class DiarioVelozFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = Time.parse options.to
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls
    puts "#{noticias_urls.count} diario veloz urls found"
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
    puts 'Fetching diario veloz sitemap ...'
    sitemap_url = 'http://www.diarioveloz.com/sitemap.xml'
    sitemap = Nokogiri::HTML open sitemap_url
    sitemap.css('url loc').map &:text
  end

  def fetch_notice url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = html.css('.title-obj h1').text
    body = html.css('.detail-obj .cuerpo-nota').text
    image = html.css('.detail-obj .slide img').first
    image = image && image.attr('src')
    media_items = Array image
    updated_time_str = html.css('.title-obj .time').text.gsub 'de', '' # Formato: '10/08/2015 21:21hs'
    updated_time = updated_time_str && Time.parse(updated_time_str)
    puts "Updated time text: '#{updated_time_str}' Updated time parsed: #{updated_time}"
    { title: title, body: body, source: :minuto_uno, source_url: url, media_items: media_items, updated_time: updated_time }
  end

end
