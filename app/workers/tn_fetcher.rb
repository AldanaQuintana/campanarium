# tn noticias fetcher

class TNFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = Time.parse options.to
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls from, to
    puts "#{noticias_urls.count} tn urls found"
    noticias_urls.map do |url|
      notice = fetch_notice url
      # notice.save!
    end
  end

  def fetch_noticias_urls from, to
    puts 'Fetching tn main sitemap ...'
    main_sitemap_url = 'http://www.tn.com.ar/sitemap.xml'
    main_sitemap = Nokogiri::HTML open main_sitemap_url
    sitemaps_urls = main_sitemap.css('sitemapindex sitemap').select do |tr|
      updated_time = Time.parse tr.css('lastmod').text
      updated_time >= from
    end.map{ |tr| tr.css('loc').text }
    noticias_urls = Array.new
    sitemaps_urls.reverse.each do |sitemap_url|
      puts "Fetching tn sitemap #{sitemap_url} ..."
      sitemap = Nokogiri::HTML open sitemap_url
      rows = sitemap.css 'urlset url'
      urls = rows.select do |row|
        updated_time = row.css('lastmod').text
        updated_time = updated_time && !updated_time.empty? && Time.parse(updated_time)
        updated_time && updated_time >= from && updated_time <= to
      end.map do |row|
        row.css('loc').text
      end.select do |url|
        !url.include? 'tnylagente'
      end
      urls.each{ |url| puts "Noticia found: #{url}"}
      noticias_urls << urls
    end
    noticias_urls.flatten
  end

  def fetch_notice url
    puts "Fetching notice in #{url} ..."
    # html = Nokogiri::HTML open url
    # title = html.css('.entry-title').first.text
    # body = format_body html.css('.entry-content .cuerposmart p')
    # image = html.css('.hmedia img').first
    # image = image && image.attr('src')
    # media_items = Array image
    # # Noticia.new title: title, body: body, source: :infobae, source_url: url, media_items: media_items
    # { title: title, body: body, source: :infobae, source_url: url, media_items: media_items }
  end

end
