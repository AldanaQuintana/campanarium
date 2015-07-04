class CreateDefaultStaticPages < ActiveRecord::Migration
  def change
    StaticPage.create(title_identifier: "Preguntas frecuentes", title: "Preguntas frecuentes")
    StaticPage.create(title_identifier: "Contacto", title: "Contacto")
    StaticPage.create(title_identifier: "Sobre el proyecto", title: "Sobre el proyecto")
  end
end
