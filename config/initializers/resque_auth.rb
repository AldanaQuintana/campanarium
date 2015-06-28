Resque::Server.use Rack::Auth::Basic do |user, password|
  user == 'resque' && password == 'resque'
end
