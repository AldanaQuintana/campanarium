class SourceFetcher < ResqueJob

  def format_body p_elements
    # formatea nodos html convirtiendolos a texto con newlines
    body = p_elements.map(&:text)*"\n"
    format_plain_body body
  end

  def format_plain_body body
    body
      .gsub(/\r|\t/, '')
      .gsub(/\ *\n\ */, "\n")
      .gsub(/\n+/, "\n")
      .gsub(/\ +/, ' ')
      .gsub(/^\ *\n*/, '')
      .gsub(/\ *\n*$/, '')
  end

  def format_title title
    title
      .gsub(/\r|\t/, '')
      .gsub("\n", ' ')
      .gsub(/\ +/, ' ')
      .gsub(/^\ *\n*/, '')
      .gsub(/\ *\n*$/, '')
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
  rescue Exception => e
    puts "Error creating media item from url #{image_src}"
    nil
  end

end
