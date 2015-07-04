class BusinessRuleError < StandardError
  def key
    if message.blank? || message == class_name
      self.class.key
    else
      message.to_sym
    end
  end

  def class_name
    self.class.name
  end

  def translated_message
    self.class.translated_message
  end

  class << self
    def translated_message
      I18n.t(self.key)
    end

    def key
      name.underscore.to_sym
    end
  end
end