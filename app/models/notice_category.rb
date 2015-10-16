class NoticeCategory

  attr_accessor :name, :keywords

  def initialize name, *keywords
    self.name = name
    self.keywords = keywords.empty? ? [name] : keywords
  end

  class << self
    def police;               new 'policiales' end
    def politics;             new 'politica' end
    def economics;            new 'economia' end
    def society;              new 'sociedad' end
    def sports;               new 'deportes' end
    def football;             new 'futbol' end
    def football_leage_one;   new 'primera_division', 'futbol', 'primera_division' end
    def football_leage_two;   new 'segunda_division', 'futbol', 'segunda_division' end
    def tecnology;            new 'tecnologia' end
    def show;                 new 'espectaculos' end
    def celebrities;          new 'celebridades' end
    def tendency;             new 'tendencia' end
  end

end
