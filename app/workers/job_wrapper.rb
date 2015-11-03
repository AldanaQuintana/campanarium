class JobWrapper < ResqueJob
  include Resque::Plugins::Status
  set_queue 'notice_fetchers_queue'

  def perform
    klass_name = options.delete 'class'
    args = options.map &:last
    eval(klass_name).perform(args)
  end

end
