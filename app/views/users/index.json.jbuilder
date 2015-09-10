json.users @users do |user|
  json.partial! "user", user: user
end
json.html_partial @html_partial