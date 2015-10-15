# encoding: utf-8
class SourceFetcher < ResqueJob

  # abstract class
  # child must implement 'notice_from(*args)'

  def initialize(options = nil)
    @options = OpenStruct.new(options || {})
  end

  def options
    @options
  end

  def fetch_notice *args
    notice = notice_from *args
    notice.save! if notice
    notice
  rescue Exception => e
    puts "Error fetching notice:\n#{e.message}\n#{e.backtrace.first(5).join("\n")}"
  end

  # formatea nodos html convirtiendolos a texto con newlines
  def format_p_body p_elements
    body = p_elements.map(&:text)*"\n"
    format_plain_body body
  end

  def format_plain_body body
    StringUtils.fix_encoding body
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

end
