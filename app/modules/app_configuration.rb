class AppConfiguration
  @@configuration = nil
  @@current = nil

  class << self
    def configuration
      @@configuration =  YAML.load_file("config/app_configuration.yml").deep_symbolize_keys[:app_configuration]
    end
  end
end