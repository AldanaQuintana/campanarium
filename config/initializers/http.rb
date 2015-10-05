Net::HTTP.class_eval do
  class << self
    alias_method :old_start, :start
  end

  def self.start(address, *arg, &block)
    self.old_start(address, *arg) do |http|
      http.read_timeout = 500
      yield(http) if block_given?
    end
  end
end