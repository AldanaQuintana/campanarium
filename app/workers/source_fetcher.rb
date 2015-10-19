# encoding: utf-8
class SourceFetcher < ResqueJob

  # abstract class
  # child must implement 'notice_from(*args)'
  # child must implement 'category_mapping()'

  def initialize(options = nil)
    @options = OpenStruct.new(options || {})
  end

  def options
    @options
  end

  def fetch_notice *args
    notice = notice_from *args
    return unless is_valid? notice
    notice.save! if notice
    notice
  rescue Exception => e
    puts "Error fetching notice:\n#{e.message}\n#{e.backtrace.first(5).join("\n")}"
  end

  def create_notice attrs={}
    title       = format_title attrs[:title]
    body        = format_body attrs[:body]
    categories  = format_categories attrs[:categories]
    keywords    = format_keywords attrs[:keywords]
    url         = attrs[:url]
    writed_at   = attrs[:writed_at]
    media       = create_media_from attrs[:media]
    source      = source_name_from_class_name
    Notice.create title: title, body: body, categories: categories, keywords: keywords,
      source: source, url: url, writed_at: writed_at, media: media
  end

  def is_valid? notice
    body = notice.body
    if !body || body.empty? || body.downcase == 'infobae'
      puts "La noticia no posee un body valido"
      false
    end
  end

  # formatea nodos html convirtiendolos a texto con newlines
  def p_body_from p_elements
    p_elements.map(&:text)*"\n"
  end

  # formatea un texto plano quitando espacios innecesarios y etc
  def format_body text
    StringUtils.fix_encoding text
      .gsub(/\r|\t/, '')
      .gsub(/\ *\n\ */, "\n")
      .gsub(/\n+/, "\n")
      .gsub(/\ +/, ' ')
      .gsub(/^\ *\n*/, '')
      .gsub(/\ *\n*$/, '')
  end

  def format_title title
    StringUtils.fix_encoding title
      .gsub(/\r|\t/, '')
      .gsub("\n", ' ')
      .gsub(/\ +/, ' ')
      .gsub(/^\ *\n*/, '')
      .gsub(/\ *\n*$/, '')
  end

  def format_keywords keywords
    Array(keywords).map do |keyword|
      StringUtils.format_keyword keyword
    end.uniq
  end

  def format_categories categories
    Array(categories).map do |channel|
      next channel if channel.is_a? NoticeCategory
      channel_name = StringUtils.format_category channel
      puts "Buscando categoria: #{channel_name}"
      category_name = category_mapping[channel_name]
      if !category_name
        puts "Categoria no encontrada: #{channel_name}"
        next nil
      end
      puts "Categoria encontrada: #{channel_name}"
      NoticeCategory.by_name category_name
    end.compact
  end

  def create_media_from *images_src
    images_src.map do |image_src|
      create_media_from_url image_src
    end.compact
  end
  
  def create_media_from_url image_src
    media = Media.new
    media.remote_image_url = image_src
    media.validate!
    media
  rescue => e
    puts "Error creating media item from url #{image_src}"
    # puts "#{e.message} #{e.backtrace.join("\n")}"
    nil
  end

  def source_name_from_class_name
    StringUtils.to_snake_case(self.class.name).gsub /\_fetcher$/, ''
  end

end
