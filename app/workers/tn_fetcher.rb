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
      notice
    end
  end

  def fetch_sitemaps_urls from, to
    puts 'Fetching tn main sitemap ...'
    main_sitemap_url = 'http://www.tn.com.ar/sitemap.xml'
    main_sitemap = Nokogiri::HTML open main_sitemap_url
    main_sitemap.css('sitemapindex sitemap').select do |tr|
      updated_time = Time.parse tr.css('lastmod').text
      updated_time >= from
    end.map{ |tr| tr.css('loc').text }
  end

  def fetch_noticias_urls_from_sitemap sitemap_url, from, to
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
      invalid_sections = %w( programas tnylagente videos node )
      invalid_sections.all?{ |section| !url.downcase.include? "/#{section}/" }
    end
    urls.each{ |url| puts "Noticia found: #{url}"}
    urls
  end

  def fetch_noticias_urls from, to
    sitemaps_urls = fetch_sitemaps_urls from, to
    noticias_urls = Array.new
    sitemaps_urls.reverse.each do |sitemap_url|
      urls = fetch_noticias_urls_from_sitemap sitemap_url, from, to
      noticias_urls.push *urls
    end
    noticias_urls
  end

  def fetch_notice url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    title = html.css('.main-content .heading .entry-title').first.text
    body = format_body html.css('.main-content .entry-content > p')
    image = html.css('.main-content .hmedia img').first
    image = image && image.attr('src')
    media_items = Array image
    # Notice.create title: title, body: body, source: :infobae, url: url #, media_items: media_items
    { title: title, body: body, source: :tn, source_url: url, media_items: media_items }
  end

end
