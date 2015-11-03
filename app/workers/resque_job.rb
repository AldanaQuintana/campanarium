class ResqueJob

  def self.perform *args
    new *args
  end

  def self.set_queue queue_name
    @queue = queue_name
  end

end
