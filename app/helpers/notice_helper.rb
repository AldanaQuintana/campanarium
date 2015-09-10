module NoticeHelper
  def source_logo(notice)
    content_tag :span, class: "source" do
      source_image(notice)
    end
  end

  def source_image(notice)
    case notice.source
    when "tn";  image_tag("logo-tn.png")
    when "infobae";  image_tag("logo-infobae.png")
    when "diario_veloz";  image_tag("logo-diario-veloz.jpg")
    when "la_nacion";  image_tag("logo-la-nacion.png")
    when "cronica"; image_tag("logo-cronica.gif")
    when "minuto_uno"; image_tag("logo-minuto-uno.jpg")
    end
  end
end