# tn noticias fetcher

class TnFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = Time.parse options.to
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls from, to
    puts "#{noticias_urls.count} tn urls found"
    noticias_urls.map do |url|
      fetch_notice url
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
    body = p_body_from html.css('.main-content .hentry .entry-content > p')
    keywords = html.css('.tag-list [rel=tag]').map &:text
    categories = html.css '.main-content .breadcrum .breadcrum-list-item .breadcrum-link'
    categories = categories && categories[1] rescue nil
    categories = categories && categories.attr('href')
    categories = categories && categories.gsub(/.*\//, '')
    image = html.css('.main-content .hmedia img').first
    image = image && image.attr('src')
    create_notice title: title, categories: categories, keywords: keywords,
      url: url, body: body, media: image
  end

  def category_mapping
    {
      'musica' => :music,
      'famosos' => :celebrities,
      'show' => :show,
      'espectaculos' => :show,
      'tecno' => :tecnology,
      'tecnologia' => :tecnology,
      'politica' => :politics,
      'policiales' => :police,
      'deportes' => :sports,
      'sociedad' => :society,
      'salud' => :health,
      'autos' => :cars
    }
  end

end
