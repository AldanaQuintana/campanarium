# infobae noticias fetcher
# Casos especiales a revisar:
# (sin body) http://opinion.infobae.com/dario-epstein/2015/07/09/otra-vez-las-propiedades-al-borde-de-una-burbuja
# (body incorrecto) http://www.infobae.com/2015/07/09/1740418-la-dieta-dilma-rousseff-bajar-15-kilos-6-meses

class InfobaeFetcher < SourceFetcher

  def perform
    from = Time.parse options.from
    to = Time.parse options.to
    fetch_noticias from, to
  end

  def fetch_noticias from, to
    noticias_urls = fetch_noticias_urls from, to
    puts "#{noticias_urls.count} infobae urls found"
    noticias_urls.each do |url|
      fetch_notice url
    end
  end

  def fetch_noticias_urls from, to
    puts 'Fetching infobae sitemap ...'
    sitemap_url = 'http://www.infobae.com/sitemap.xml'
    sitemap = Nokogiri::HTML open sitemap_url
    noticias_urls = sitemap.css('url loc').map &:text
    noticias_urls.select do |url|
      time = time_from url
      time && time >= from && time <= to
    end
  end

  def notice_from url
    puts "Fetching notice in #{url} ..."
    html = Nokogiri::HTML open url
    # title = html.css('meta[itemprop=name]').attr('content').text
    title = html.css('.entry-title').first.text
    body = p_body_from html.css '.entry-content .cuerposmart p'
    keywords = html.css('.entry-content .tags [rel=tag]').map &:text
    categories = html.css('article a[data-header-tag]')
    categories = categories && categories.attr('href')
    categories = categories && categories.text.gsub(/^.*infobae\.com\//, '')
    binding.pry if !categories
    image = html.css('.hmedia img').first
    image = image && image.attr('src')
    writed_at = time_from url
    create_notice title: title, categories: categories, keywords: keywords,
      url: url, writed_at: writed_at, body: body, media: image
  end

  def time_from url
    Time.parse url[/\d{4}\/\d{2}\/\d{2}/]
  rescue TypeError => e
    nil
  end

  def category_mapping
    # las categorias corresponden a la ultima parte del link en infobae
    # por ejemplo, "tecno" en realidad es "tecnologia", ya que sale de "www.infobae.com/tecnologia"
    {
      'politica' =>               :politics,
      'policiales' =>             :police,
      'finanzas & negocios' =>    :economics,
      'economia' =>               :economics,
      'sociedad' =>               :society,
      'playfutbol' =>             :sports,
      'deportes' =>               :sports,
      'playfutbol/primera' =>     :football_leage_one,
      'torneo-largo-2015' =>      :football_leage_one,
      'playfutbol/b-nacional' =>  :football_leage_two,
      'tecnologia' =>             :tecnology,
      'infoshow' =>               :show,
      'nutriglam' =>              :health,
      'tendencias' =>             :tendency
    }
  end

end
