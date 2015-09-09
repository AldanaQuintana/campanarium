# encoding: utf-8
class SourceFetcher < ResqueJob

  # abstract class
  # child must implement 'notice_from(*args)'

  def fetch_notice *args
    notice = notice_from *args
    notice.save! if notice
    notice
  rescue Exception => e
    puts "Error fetching notice: #{e.message} #{e.backtrace.join("\n")}"
  end

  def format_body p_elements
    # formatea nodos html convirtiendolos a texto con newlines
    body = p_elements.map(&:text)*"\n"
    format_plain_body body
  end

  def format_plain_body body
    fix_encoding body
      .gsub(/\r|\t/, '')
      .gsub(/\ *\n\ */, "\n")
      .gsub(/\n+/, "\n")
      .gsub(/\ +/, ' ')
      .gsub(/^\ *\n*/, '')
      .gsub(/\ *\n*$/, '')
  end

  def format_title title
    fix_encoding title
      .gsub(/\r|\t/, '')
      .gsub("\n", ' ')
      .gsub(/\ +/, ' ')
      .gsub(/^\ *\n*/, '')
      .gsub(/\ *\n*$/, '')
  end

  def format_keywords keywords
    Array(keywords).map do |keyword|
      fix_encoding keyword.downcase
    end
  end

  def create_media_from *images_src
    images_src.map do |image_src|
      create_media_from_url image_src
    end.compact
  end

  def create_media_from_url image_src
    media = Media.new
    media.remote_image_url = image_src
    media
  rescue Exception
    puts "Error creating media item from url #{image_src}"
    nil
  end

  private

  def fix_encoding text 
    return text unless text =~ /[ÂÃ]/ #se podria mejorar, pero creo que para lo que necesitamos funciona
    text.encode("iso-8859-1").force_encoding("utf-8")
  end

end
