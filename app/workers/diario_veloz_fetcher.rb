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
    noticias_urls.each do |url|
      next nil unless belongs_to_interval
      notice = fetch_notice url
      next unless notice
      updated_time = notice.writed_at
      belongs_to_interval = updated_time && updated_time >= from && updated_time <= to
    end
  end

  def fetch_noticias_urls
    puts 'Fetching diario veloz sitemap ...'
    sitemap_url = 'http://www.diarioveloz.com/sitemap.xml'
    sitemap = Nokogiri::HTML open sitemap_url
    sitemap.css('url loc').map &:text
  end

  def notice_from url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = format_title html.css('.title-obj h1').text
    body = format_plain_body html.css('.detail-obj .cuerpo-nota').text
    image = html.css('.detail-obj .slide img').first
    image = image && image.attr('src')
    updated_time_str = html.css('.title-obj .time').text.gsub 'de', '' # Formato: '10/08/2015 21:21hs'
    updated_time = updated_time_str && Time.parse(updated_time_str)
    puts "Updated time text: '#{updated_time_str}' Updated time parsed: #{updated_time}"
    media_items = create_media_from image
    Notice.create title: title, body: body, source: :diario_veloz, url: url, writed_at: updated_time, media: media_items
  end

end
