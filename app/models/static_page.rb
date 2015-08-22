class StaticPage < ActiveRecord::Base
  validates :title_identifier, uniqueness: { case_sensitive: false }
  validates_presence_of :title_identifier

  before_create :set_default_values

  def to_param
    "#{title_identifier.parameterize}"
  end

  def set_default_values
    self.title = title_identifier.try(:titleize) if title.nil?
  end

  class << self
    def find_by_param_name(param_name)
      self.where("lower(title_identifier) = ?", param_name.titleize.downcase)[0]
    end

    def about_us
      StaticPage.find_or_create_by(title_identifier: "Sobre el proyecto")
    end

    def faqs
      StaticPage.find_or_create_by(title_identifier: "Preguntas frecuentes")
    end

    def contact
      StaticPage.find_or_create_by(title_identifier: "Contacto")
    end

    def ordered_by_name
      self.order(:title_identifier)
    end
  end
end