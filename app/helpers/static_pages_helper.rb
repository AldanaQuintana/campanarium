module StaticPagesHelper
  def static_page_mercury_path(page)
    "editor/" + edit_static_page_path(page)
  end
end