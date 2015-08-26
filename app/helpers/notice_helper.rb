module NoticeHelper
  def source_logo(notice)
    content_tag :span, class: "source" do
      source_image(notice)
    end
  end

  def source_image(notice)
    case notice.source
    when "tn";  image_tag("logo-tn.png")
    end
  end
end