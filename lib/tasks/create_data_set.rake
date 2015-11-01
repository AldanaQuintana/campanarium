require 'support/notice_groups_data_set'

namespace :data_set do
  desc "Create data set"
  task :create => :environment do
    Admin.create(name: "Admin", email: "admin@campanarium.com",
      password: "password", password_confirmation: "password")
  end

  task :create_dummy_data => :environment do
    to = Time.zone.now
    from = to - 2.hours
    fetchers = [TnFetcher, LaNacionFetcher,
      InfobaeFetcher, CronicaFetcher,
      PaginaDoceFetcher, InfoNewsFetcher]
    fetchers.each do |fetcher|
      begin
        fetcher.new({from: from.to_s, to: to.to_s}).perform
      rescue Exception => e
        puts e
        puts "Error with #{fetcher.class}"
      end
    end
    CommentsFetcher.new.search_and_persist "noticias"
    20.times.each{ NoticeGroup.create(
      comments: Comment.where(notice_group_id: nil).limit(20),
      notices: Notice.where(notice_group_id: nil).limit(rand(2..6))
    )}
    Comment.where("notice_group_id is not null").find_each do |comment|
      comment.update_attributes(positive: rand(1..7) <= 5)
    end
    30.times.each{|t| User.create(
      name: "Usuario nro #{t}",
      email: "user_#{t}@email.com",
      password: "password",
      password_confirmation: "password"
    )}
  end
end
