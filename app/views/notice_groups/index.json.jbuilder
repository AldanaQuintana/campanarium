json.groups @notice_groups do |group|
  json.notices group.notices do |notice|
    json.partial! "notice", notice: notice
  end
end
json.show_edit current_admin_user?