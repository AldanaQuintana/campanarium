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
    can :noticias, :show
    can :edit, user
    can :users, :index
  end

  def admin_permissions(user)

  end
end
