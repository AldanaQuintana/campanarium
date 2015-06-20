class StaticPage < ActiveRecord::Base
  validates :title, uniqueness: { case_sensitive: false }
  validates_presence_of :title

  def to_param
    "#{title.parameterize}"
  end

  class << self
    def find_by_param_name(param_name)
      self.where("lower(title) = ?", param_name.titleize.downcase)[0]
    end
  end
end