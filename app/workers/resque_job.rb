class ResqueJob

  def self.perform *args
    new *args
  end

  def self.queue queue_name
    @queue = queue_name
  end

end
