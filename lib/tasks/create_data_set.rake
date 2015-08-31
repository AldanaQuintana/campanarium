require 'support/notice_groups_data_set'

namespace :data_set do
  desc "Create data set"
  task :create => :environment do
    NoticeGroupsDataSet.create_groups
  end
end
