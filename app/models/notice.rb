class Notice < ActiveRecord::Base

  has_many :media, class_name: :Media
  belongs_to :notice_group

end
