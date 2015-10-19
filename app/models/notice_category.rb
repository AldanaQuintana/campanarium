class NoticeCategory

  class << self
    def define_category name, *args
      category = new name, *args
      define_singleton_method name do
        category
      end
    end
    def by_name name
      send name
    end
    def load value
      category_names = JSON.load value
      return Array.new unless category_names
      category_names.map{ |category_name| send category_name }
    end
    def dump categories
      category_names = categories.map &:name
      JSON.dump category_names
    end
  end

  attr_accessor :name, :keywords

  def initialize name, *keywords
    self.name = name
    self.keywords = keywords
  end

  define_category :police,               'policiales'
  define_category :politics,             'politica'
  define_category :economics,            'economia'
  define_category :society,              'sociedad'
  define_category :sports,               'deportes'
  define_category :rugby,                'deportes', 'rugby'
  define_category :tenis,                'deportes', 'tenis'
  define_category :basquet,              'deportes', 'basquet'
  define_category :football,             'deportes', 'futbol'
  define_category :football_leage_one,   'deportes', 'futbol', 'primera_division'
  define_category :football_leage_two,   'deportes', 'futbol', 'segunda_division'
  define_category :tecnology,            'tecnologia'
  define_category :show,                 'espectaculos'
  define_category :celebrities,          'celebridades'
  define_category :music,                'musica'
  define_category :tendency,             'tendencia'
  define_category :travel,               'turismo'
  define_category :health,               'salud'
  define_category :cars,                 'autos'

end
