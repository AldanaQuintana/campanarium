class AppConfiguration
  @@configuration = nil
  @@current = nil

  class << self
    def configuration
      @@configuration =  YAML.load_file("config/app_configuration.yml").deep_symbolize_keys[:app_configuration]
    end

    def semantic_analyzer_response_url
      "http://#{self.configuration[:host]}:#{self.configuration[:port]}/response_from_analyzer"
    end

    def sentiments_analyzer_response_url
      "http://#{self.configuration[:host]}:#{self.configuration[:port]}/response_from_sentiments_analyzer"
    end
  end
end