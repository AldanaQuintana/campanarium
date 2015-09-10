module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from BusinessRuleError, with: :busines_rule_error_handler
    rescue_from CanCan::AccessDenied, with: :cancan_error_handler
  end

  def busines_rule_error_handler(exception)
    flash[:danger] = I18n.t(exception.key)
    redirect_to root_path
  end

  def cancan_error_handler(exception)
    flash[:danger] = I18n.t(".error_not_authorized") + " Debe ingresar antes."
    redirect_to root_path
  end

end