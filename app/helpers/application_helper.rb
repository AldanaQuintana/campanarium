module ApplicationHelper
  def current_admin_user?
    current_user.present? && current_user.admin?
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
end
