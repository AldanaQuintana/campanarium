module ApplicationHelper
  def current_admin_user?
    # TODO
    true
  end


  def signin_path(provider)
    "users/auth/#{provider.to_s}"
  end
end
