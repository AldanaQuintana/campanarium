class StaticPage < ActiveRecord::Base
  validates :title_identifier, uniqueness: { case_sensitive: false }
  validates_presence_of :title_identifier
  validates_presence_of :title

  def to_param
    "#{title_identifier.parameterize}"
  end

  class << self
    def find_by_param_name(param_name)
      self.where("lower(title_identifier) = ?", param_name.titleize.downcase)[0]
    end
  end
end