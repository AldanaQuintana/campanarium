class Notice < ActiveRecord::Base

  has_many :media, class_name: :Media

end
