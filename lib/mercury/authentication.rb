module Mercury
  module Authentication

    def can_edit?
      if current_user.present? && current_user.admin?
        true
      else
        flash[:danger] = I18n.t(".error_not_authorized")
        redirect_to root_path
      end
   end

 end
end