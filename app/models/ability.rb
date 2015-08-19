class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    user_permissions(user)

    if user.admin?
        admin_permissions(user)
    end
  end

  def user_permissions(user)
    can :noticias, :index
    can :edit, user 
  end

  def admin_permissions(user)

  end
end
