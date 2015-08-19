module ApplicationHelper
  def current_admin_user?
    current_user.present? && current_user.admin?
  end

  def render_alert_messages?
    request.path != "/users/sign_in"
  end

  def signin_path(provider)
    "users/auth/#{provider.to_s}"
  end

  def error_class_for(resource, attribute)
    resource.present? && resource.errors[attribute].present? ? "has-error" : ""
  end

  def bootstrap_alert_class(alert_type)

    case alert_type
      when :notice; return 'alert-success'
      when :alert; return 'alert-danger'
    end

    return "alert-#{alert_type}"
  end

  def alert_icon_class(alert_type)
    alert_type = alert_type.try(:to_sym)
    case alert_type
      when :notice; return 'fa-info'
      when :alert; return 'fa-exclamation'
      when :danger; return 'fa-exclamation-triangle'
    end
  end
end
