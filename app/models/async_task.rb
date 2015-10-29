class AsyncTask < ActiveRecord::Base

  def stopped?
    self.status != "running"
  end
end