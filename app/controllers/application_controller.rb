class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ExceptionHandler
  include Mercury::Authentication

  helper_method :editing?

  def authenticate_admin_user!
    current_user.present? &&
    current_user.admin? or raise BusinessRuleError.new :error_not_authorized
  end

  def after_sign_in_path_for(resource)
    noticias_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def editing?
    request.path.index("/editor/") == 0
  end
end
