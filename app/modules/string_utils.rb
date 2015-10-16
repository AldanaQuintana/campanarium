module StringUtils
  class << self

    # corrige los problemas de encoding de diario veloz y cia.
    def fix_encoding text
      return text unless text =~ /[ÂÃ]/
      text.encode("iso-8859-1").force_encoding("utf-8")
    end

    # formatea palabras, eliminado simbolos raros y agregando espacios
    def format_keyword keyword
      I18n.transliterate(keyword)           # removes accents and weird symbols
        .split(/\s*(\d+)\s*/, -1).join ' '  # adds whitespaces between numbers and letters
        .split.join ' '                     # gets rid of multiple whitespaces
        .strip.downcase
    end

    # string to "underscore" case
    def to_snake_case string
      string.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        .gsub(/([a-z\d])([A-Z])/,'\1_\2')
        .tr("-", "_")
        .downcase
    end

  end
end
